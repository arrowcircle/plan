require 'rails_helper'
require 'support/user_macros'

feature 'Изделия' do
  before(:each) { login }

  scenario 'добавляет базовое изделие' do
    visit items_path
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :item_name, with: name
    fill_in :item_articul, with: name
    click_button I18n.t('save')
    expect(page).to have_content name
    expect(page).to have_content 'Изделие добавлено'
  end
end
