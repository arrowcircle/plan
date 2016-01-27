require 'rails_helper'
require 'support/user_macros'

feature 'Планы' do
  before(:each) do
    login
  end
  let(:root) { create(:root) }
  let(:parent) { create(:item, account_id: root.account_id) }
  let(:item) { create(:item, account_id: root.account_id) }
  let(:subitem) { create(:item, account_id: root.account_id) }
  let(:plan) { create(:plan) }

  scenario 'добавляет план' do
    visit plans_path
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :plan_name, with: name
    click_button I18n.t('save')
    expect(page).to have_content name
    expect(page).to have_content 'План добавлен'
  end

  scenario 'удаляет план' do
    visit plans_path
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :plan_name, with: name
    click_button I18n.t('save')
    expect { click_link I18n.t('delete'), match: :first }.to change(Plan, :count).by(-1)
  end

  scenario 'добавление изделия в план' do
    pending("настройка javascript")
    visit plans_path
    click_link I18n.t('new'), match: :first
    name = FFaker::Product.product_name
    fill_in :plan_name, with: name
    click_link I18n.t('add_item'), match: :first
    fill_in :item_name, with: parent.articul
    fill_in :quantity, with: 2
    click_button I18n.t('save')
    expect(page).to have_content name
  end

  scenario 'просмотр плана' do
    pending("настройка javascript")
    Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
    Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
    Planezation.create(plan_id: plan.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
    Planezation.create(plan_id: plan.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
    visit plan_path(plan)
    expect(page).to have_content item.name
    expect(page).to have_content subitem.name
  end
end
