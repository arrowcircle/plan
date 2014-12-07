require 'rails_helper'
require 'support/user_macros'

feature 'Инвайты' do
  before(:each) { login; visit root_url; click_link(I18n.t('layouts.application.invites')) }
  let(:invite) { create(:invite) }

  scenario 'юзер приглашает нового юзера' do
    click_link I18n.t('invites.index.new')
    email = Faker::Internet.email
    find('#invite_emails', match: :first).set(email)
    click_button I18n.t('save')
    expect(page).to have_content 'Мы отправили приглашения на указанные емейлы'
  end

  scenario 'юзер приглашает сушествующего юзера' do
    click_link I18n.t('invites.index.new')
    inv_user = create(:user_with_account)
    find('#invite_emails', match: :first).set(inv_user.email)
    click_button I18n.t('save')
    expect(page).to have_content 'Мы отправили приглашения на указанные емейлы'
    expect(page).to have_content inv_user.name
  end

  scenario 'юзер удаляет пользователя из аккаунта' do
    user = User.first
    duser = create(:user)
    AccountUser.create(user_id: duser.id, account_id: user.accounts.first.id)
    click_link(I18n.t('layouts.application.invites'))
    expect(page).to have_content duser.name
    click_link 'Удалить'
    expect(page).not_to have_content duser.name
  end

  scenario 'юзер удаляет инвайт' do
    user = User.first
    Invite.create(account_id: user.accounts.first.id, email: 'abc@test.ru')
    click_link(I18n.t('layouts.application.invites'))
    expect(page).to have_content 'abc@test.ru'
    click_link I18n.t('delete')
    expect(page).not_to have_content 'abc@test.ru'
  end

  scenario 'юзер регистрируется по инвайту' do
    visit "/invites/#{invite.token}"
    fill_in :invite_name, with: Faker::Name.name
    fill_in :invite_password, with: '123123aA'
    click_button  I18n.t('save')
    expect(page).to have_content 'успешно'
  end
end
