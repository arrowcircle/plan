class Inviter
  include ActiveModel::Model

  attr_accessor :emails, :account_id

  def self.model_name
    Invite.model_name
  end

  def invite
    fix_emails
    add_account_users
    create_invites
    true
  end

  def fix_emails
    @emails = [] unless @emails.present?
    @emails = Array(@emails) unless @emails.is_a?(Array)
    @emails = @emails.select { |i| i.present? }.uniq
  end

  def add_account_users
    users.each do |user|
      AccountUser.create(account_id: account_id, user_id: user.id) unless AccountUser.where(account_id: account_id, user_id: user.id).any?
    end
  end

  def create_invites
    invite_emails.each do |email|
      Invite.create(email: email, account_id: account_id) unless Invite.inactive.where(email: email, account_id: account_id).any?
    end
  end

  def invite_emails
    emails - users.pluck(:email)
  end

  def users
    @users ||= User.where(email: emails)
  end
end
