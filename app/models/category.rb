class Category < ActiveRecord::Base
  include TreeSortable
  belongs_to :account
  has_many :items

  has_ancestry

  scope :for_account, ->(account_id) { where("account_id = :account_id OR account_id IS NULL", account_id: account_id) }

  validates :name, presence: true

  def tree_ids
    return [] if new_record?
    Rails.cache.fetch(self) do
      ancestor_ids + subtree_ids
    end
  end

  def destroy
    self.errors.add(:base, 'Невозможно удалить корневую категорию с наследниками') if children.any?
    return super if errors.blank?
    false
  end

  def set_position(item)
  end
end

class Category::Complex < Category
  def self.model_name
    Category.model_name
  end

  def set_position(item)
    item.position = item.articul.gsub(/[^\d]/, '').try(:to_i)
  end
end
