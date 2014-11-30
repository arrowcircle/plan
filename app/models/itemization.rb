class Itemization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Item'
  belongs_to :item
  belongs_to :account

  validates :parent, :item, :quantity, presence: true
  validates :account, presence: true

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def to_tree
    { item.id => quantity }
  end
end
