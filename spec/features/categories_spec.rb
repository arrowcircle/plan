require 'rails_helper'
require 'support/user_macros'

feature 'Категории' do
  before(:each) { login }

  scenario 'добавляет корневую категорию' do
    visit categories_path
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :category_name, with: name
    select('Обычная', from: 'Тип категории')
    click_button I18n.t('save')
    expect(page).to have_content name
    expect(page).to have_content 'Категория добавлена'
  end

  scenario 'добавляет детскую категорию' do
    visit categories_path
    category = create(:category)
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :category_name, with: name
    select('Для сборок', from: 'Тип категории')
    select(category.name, from: 'Родительская категория')
    click_button I18n.t('save')
    # expect(page).to have_content name
    expect(page).to have_content 'Категория добавлена'
  end
end
