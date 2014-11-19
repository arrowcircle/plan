class Item < ActiveRecord::Base
  has_many :itemizations, foreign_key: :parent_id
  has_many :items, through: :itemizations

  accepts_nested_attributes_for :itemizations, allow_destroy: true

  def self.basic
    Item.where.not(id: Itemization.pluck(:parent_id).uniq)
  end

  def self.complex
    # All parent ids - all children ids
    Item.where(id: (Itemization.pluck(:parent_id).uniq - Itemization.pluck(:item_id).uniq))
  end

  def self.search(q = '')
    return all if q && q.size < 3
    Item.where("name ILIKE :q", q: "%#{q}%")
  end

  def children
    Itemization.where(parent_id: id)
  end

  def self.tree_for(item)
    item.children.includes(:item).inject([]) do |memo, child|
      item = child.item
      if item.children.any?
        memo += Item.tree_for(item) * child.quantity
      else
        memo += [child.to_tree]
      end
    end
  end

  def tree
    content = Item.tree_for(self).inject { |memo, el| memo.merge(el) { |k, old_v, new_v| old_v + new_v } }
    return {} if content == {} || content.nil?
    Item.where(id: content.keys.uniq).inject({}) do |memo, item|
      memo.merge(content[item.id] => item)
    end
  end

  def tre
    subtree = self.class.tree_sql_for(self)
    Item.where("category_id IN (#{subtree})")
  end

  def self.tre_for(instance)
    where("#{table_name}.id IN (#{tree_sql_for(instance)})").order("#{table_name}.id")
  end

  def self.tree_sql_for(instance)
    tree_sql =  <<-SQL
      WITH RECURSIVE search_tree(id, path) AS (
          SELECT id, ARRAY[id]
          FROM #{table_name}
          WHERE id = #{instance.id}
        UNION ALL
          SELECT #{table_name}.id, path || #{table_name}.id
          FROM search_tree
          JOIN #{table_name} ON #{table_name}.parent_id = search_tree.id
          WHERE NOT #{table_name}.id = ANY(path)
      )
      SELECT id FROM search_tree ORDER BY path
    SQL
  end
end
