require 'rails_helper'

describe Plan do
  let(:root) { create(:root) }
  let(:item) { create(:item, account_id: root.account_id) }
  let(:parent) { create(:item, account_id: root.account_id) }
  let(:subitem) { create(:item, account_id: root.account_id) }
  let(:plan) { create(:plan) }

  context 'Список' do
    it 'возвращает пустой хеш для пустого плана' do
      expect(plan.plan).to eq Hash.new
    end

    it 'возвращает сумарное количество для 2х одинаковых базовых элементов' do
      Planezation.create(plan_id: plan.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Planezation.create(plan_id: plan.id, item_id: item.id, quantity: 2, account_id: parent.account_id)
      expect(plan.plan.values).to eq [3.0]
    end

    it 'возвращает количество для 2х разных базовых элементов' do
      Planezation.create(plan_id: plan.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Planezation.create(plan_id: plan.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
      expect(plan.plan.values).to eq [1.0,2.0]
    end

    it 'возвращает количество базовых елементов для составного изделия' do
      Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
      Planezation.create(plan_id: plan.id, item_id: parent.id, quantity: 1, account_id: parent.account_id)
      expect(plan.plan.values).to eq [1.0,2.0]
    end
  end
end
