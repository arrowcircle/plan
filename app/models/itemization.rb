class Itemization < ActiveRecord::Base
  belongs_to :parent, class_name: 'Item'
  belongs_to :item

  validates :parent, :item, :quantity, presence: true

  def to_tree
    { item.id => quantity }
  end
end
