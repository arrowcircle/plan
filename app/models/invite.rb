class Invite < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  validates :account_id, presence: true

  scope :for_account, ->(account_id) { where(account_id: account_id) }
  scope :inactive, -> { where(user_id: nil) }

  before_create :generate_token

  def to_param
    token
  end

  protected

  def generate_token
    self.token = SecureRandom.urlsafe_base64
    generate_token if Invite.exists?(token: self.token)
  end
end
