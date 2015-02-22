class Plan < ActiveRecord::Base
  Plan::Calculator
  enum status: [:active, :completed]
  has_many :planezations
  has_many :items, through: :planezations
  belongs_to :account

  accepts_nested_attributes_for :planezations, allow_destroy: true

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  validates :account, presence: true

  def self.search(q = '')
    return Plan if q && q.size < 2
    Plan.where("name ILIKE :q", q: "%#{q}%")
  end

  def plan
    Plan::Calculator.new(self).plans
  end
end
