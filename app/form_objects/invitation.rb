class Invitation
  include ActiveModel::Model
  extend ActiveModel::Translation

  attr_accessor :invite, :name, :password, :user

  validates :name, :password, presence: true
  validates :password, complex_password: true

  def register
    return false unless valid?
    persist!
    true
  end

  def persisted?
    false
  end

  def persist!
    @user = User.create!(email: invite.email, name: name, password: password)
    AccountUser.create!(user_id: @user.id, account_id: invite.account_id) unless AccountUser.where(user_id: @user.id, account_id: invite.account_id).any?
    invite.destroy!
  end

  def self.model_name
    Invite.model_name
  end
end
