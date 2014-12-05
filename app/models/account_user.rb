class AccountUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  validates :user_id, :account_id, presence: true
end
