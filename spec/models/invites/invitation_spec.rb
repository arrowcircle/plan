require 'rails_helper'

describe Invitation do
  let(:invite) { create(:invite) }
  let(:inv) { Invitation.new(invite: invite, name: Faker::Name.name, password: '123123aA') }

  it 'создает пользователя' do
    expect(inv.register).to eq true
    expect(inv.user.email).to eq invite.email
    expect(inv.user.valid?).to eq true
  end

  it 'создает acount user' do
    inv.register
    expect(AccountUser.where(account_id: invite.account_id, user_id: inv.user.id).any?).to eq true
  end
end
