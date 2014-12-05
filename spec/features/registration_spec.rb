require 'rails_helper'

feature 'Регистрация' do
  before(:each) do
    visit root_url
    click_link I18n.t('main.index.start')
    fill_in 'registration_email', with: Faker::Internet.email
    fill_in 'registration_name', with: Faker::Name.name
    fill_in 'registration_password', with: '123123aA'
    fill_in 'registration_company', with: Faker::Company.name
  end

  it 'посетитель регистрирует аккаунт' do
    click_button I18n.t('registrations.new.sign_up')
    expect(page).to have_content I18n.t('registrations.create.welcome')
  end

  it 'не регистрирует без имени компании' do
    fill_in 'registration_company', with: ''
    click_button I18n.t('registrations.new.sign_up')
    expect(page).not_to have_content I18n.t('registrations.create.welcome')
  end
end
