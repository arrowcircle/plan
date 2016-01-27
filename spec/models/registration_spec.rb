require 'rails_helper'

describe Registration do
  let(:reg) { Registration.new(email: FFaker::Internet.email, name: FFaker::Name.name, password: '123123aA', company: FFaker::Company.name) }
  it 'создает аккаунт для пользователя' do
    reg.register
    expect(reg.user.accounts.count).to eq 1
  end

  it 'прикрепляет пользователя к аккаунту как админа' do
    reg.register
    expect(reg.user.accounts.first.owner_id).to eq reg.user.id
  end

  it 'создает account_user' do
    reg.register
    au = AccountUser.first
    expect(au.user_id).to eq reg.user.id
    expect(au.account_id).to eq reg.user.owned_accounts.first.id
  end

  it 'проверяет пользователя на уникальность' do
    user = create(:user)
    reg.email = user.email
    expect(reg.register).to eq false
    expect(reg.errors.size).to eq 1
  end
end
