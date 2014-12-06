require 'rails_helper'

describe Inviter do
  let(:user) { create(:user) }
  context '#fix_emails' do
    it 'работает с пустыми емейлами' do
      inviter = Inviter.new
      inviter.fix_emails
      expect(inviter.emails).to eq []
    end

    it 'уникумирует емейлы' do
      inviter = Inviter.new(emails: ["abc@test.ru", "abc@test.ru"])
      inviter.fix_emails
      expect(inviter.emails).to eq ["abc@test.ru"]
    end

    it 'работает с нулевыми емейлами' do
      inviter = Inviter.new(emails: ["abc@test.ru", nil, ""])
      inviter.fix_emails
      expect(inviter.emails).to eq ["abc@test.ru"]
    end

    it 'делает из строки массив' do
      inviter = Inviter.new(emails: "abc@test.ru")
      inviter.fix_emails
      expect(inviter.emails).to eq ["abc@test.ru"]
    end
  end

  it 'достает емейлы для инвайтов' do
    inviter = Inviter.new(emails: [user.email, 'abc@test.ru'])
    expect(inviter.invite_emails).to eq ['abc@test.ru']
  end

  it 'достает пользователей' do
    inviter = Inviter.new(emails: [user.email, 'abc@test.ru'])
    expect(inviter.users).to eq [user]
  end

  it 'создает инвайты' do
    user = create(:user_with_account)
    inviter = Inviter.new(emails: ['abc@test.ru'], account_id: Account.first.id)
    inviter.invite
    expect(Invite.first.email).to eq 'abc@test.ru'
  end

  it 'создает аккаунт_юзера' do
    user = create(:user_with_account)
    ac_id = Account.first.id + 1
    inviter = Inviter.new(emails: [user.email], account_id: ac_id)
    inviter.invite
    expect(AccountUser.where(user_id: user.id, account_id: ac_id).any?).to eq true
  end
end
