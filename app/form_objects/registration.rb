class Registration
  include ActiveModel::Model
  extend ActiveModel::Translation

  validates :name, :password, :company, presence: true
  validates :email, email: true, presence: true
  validate :email_is_unique
  validates :password, complex_password: true

  attr_accessor :email, :name, :password, :company, :user, :account

  def persisted?
    false
  end

  def email_is_unique
    errors.add(:email, 'уже занят') if User.where(email: email).any?
  end

  def register
    return false unless valid?
    persist!
    true
  end

  def persist!
    @user = User.create!(email: email, name: name, password: password)
    @account = Account.create!(name: company, owner_id: @user.id)
    AccountUser.create!(user_id: @user.id, account_id: @account.id) unless AccountUser.where(user_id: @user.id, account_id: @account.id).any?
  end
end
