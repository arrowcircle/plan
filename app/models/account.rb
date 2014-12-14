class Account < ActiveRecord::Base
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users
  has_many :items
  has_many :itemizations
  has_many :plans
  has_many :planezations
  belongs_to :owner, class_name: 'User'
  validates :owner, presence: true
end
