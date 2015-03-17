class Planezation < ActiveRecord::Base
  belongs_to :plan
  belongs_to :item, inverse_of: :planezations
  belongs_to :account

  validates :item, :quantity, :account, presence: true

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def progress
    qty = complete || 0.0
    complete * 100 / (quantity || 1)
  end
end
