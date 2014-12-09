class Itemization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Item', inverse_of: :parent_itemizations
  belongs_to :item, inverse_of: :itemizations
  belongs_to :account

  validates :item, :quantity, :account, presence: true
  validate :infinite_loop

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  attr_accessor :articul

  def to_tree
    { item.id => quantity }
  end

  private

  def infinite_loop
    errors[:base] << 'Ошибка зацикливания связей' if Itemization.where(parent_id: item_id, item_id: parent_id).any?
  end
end
