class Item < ActiveRecord::Base
  has_many :itemizations, foreign_key: :parent_id, inverse_of: :item
  has_many :items, through: :itemizations
  belongs_to :account

  scope :for_account, ->(account_id) { where(account_id: account_id) }
  scope :basic, ->(account_id) { where.not(id: Itemization.for_account(account_id).pluck(:parent_id).uniq) }
  # All parent ids - all children ids
  scope :complex, ->(account_id) { Item.where(id: (Itemization.for_account(account_id).pluck(:parent_id).uniq - Itemization.for_account(account_id).pluck(:item_id).uniq)) }

  accepts_nested_attributes_for :itemizations, allow_destroy: true
  validates :account, presence: true

  def self.search(q = '')
    return all if q && q.size < 3
    Item.where("name ILIKE :q", q: "%#{q}%")
  end

  def children
    Itemization.where(parent_id: id, account_id: account_id)
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
    Item.where(id: content.keys.uniq, account_id: account_id).inject({}) do |memo, item|
      memo.merge(content[item.id] => item)
    end
  end
end
