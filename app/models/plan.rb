class Plan < ActiveRecord::Base
  enum status: [ :active, :completed ]
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

  def self.list(plan)
    hash=Hash.new
    plan.planezations.each do |planez|
      treehash=planez.item.tree
      if treehash.blank?
        treehash[planez.item]=planez.quantity
      else
        treehash.each do |key, value|
          treehash[key]=value*planez.quantity
        end
      end
     hash.merge!(treehash) do |key, oldval, newval|
       oldval+newval
     end
    end
    hash
  end

end
