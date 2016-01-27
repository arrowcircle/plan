class Item < ActiveRecord::Base
  has_many :itemizations
  has_many :parent_itemizations, foreign_key: :parent_id, class_name: 'Itemization'
  has_many :items, through: :itemizations
  has_many :plans, through: :planezations
  has_many :planezations
  belongs_to :account
  belongs_to :category

  scope :for_account, ->(account_id) { where("account_id = :account_id OR account_id IS NULL", account_id: account_id) }
  scope :basic, ->(account_id) { where.not(id: Itemization.for_account(account_id).pluck(:parent_id).uniq) }
  # All parent ids - all children ids
  scope :final, ->(account_id) { Item.where(id: (Itemization.for_account(account_id).pluck(:parent_id).uniq - Itemization.for_account(account_id).pluck(:item_id).uniq)) }
  scope :complex, ->(account_id) { Item.where(id: Itemization.for_account(account_id).pluck(:parent_id)) }
  scope :for_category, ->(account_id, category_id) { for_account(account_id).where(category_id: Category.for_account(account_id).where(id: category_id).first.tree_ids) }

  accepts_nested_attributes_for :itemizations, allow_destroy: true
  accepts_nested_attributes_for :parent_itemizations, allow_destroy: true

  validates :account, presence: true
  validates :articul, uniqueness: { case_sensitive: false, scope: :account_id }, presence: true
  validates :name, presence: true

  before_save :set_position

  def self.search(q = '')
    return Item if q && q.size < 2
    Item.where("articul ILIKE :q OR name ILIKE :q", q: "%#{q}%")
  end

  def children_count
    Itemization.where(parent_id: id, account_id: account_id).count
  end

  def children
    Itemization.select("itemizations.*, count(children) as children_count")
    .joins('left join items on items.id = itemizations.item_id')
    .joins('left join itemizations as children on children.parent_id = items.id')
    .where(parent_id: id, account_id: account_id).group('itemizations.id').order('children_count DESC')
  end

  def parents
    Item.select('items.*, max(itemizations.quantity) as quantity').joins(:itemizations).where('itemizations.item_id' => id).group('items.id')
  end

  def self.tree_for(item)
    item.children.includes(:item).inject([]) do |memo, child|
      item = child.item
      if item.children_count > 0
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
      memo.merge(item => content[item.id])
    end
  end

  def full_name
    return "#{articul} (#{name})" if name.present? && name != articul
    articul
  end

  def set_position
    return true unless category.present?
    category.set_position(self)
  end
end
