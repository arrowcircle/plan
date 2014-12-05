require 'rails_helper'

describe Item do
  let(:root) { create(:root) }
  let(:item) { create(:item, account_id: root.account_id) }
  let(:parent) { create(:item, account_id: root.account_id) }
  let(:subitem) { create(:item, account_id: root.account_id) }

  context 'Дерево' do
    it 'возвращает пустой массиов для пустого дерева' do
      expect(parent.tree).to eq Hash.new
    end

    it 'возвращает плоский массив для 2х элементов' do
      Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
      expect(parent.tree.keys).to eq [1, 2]
    end

    it 'выводит список компонентов для корня' do
      expect(root.tree.keys).to eq [2, 4, 1]
    end
  end

  context 'Скоупы' do
    it 'достает базовые изделия' do
      Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
      expect(Item.basic(parent.account_id).pluck(:id).include?(parent.id)).to eq false
    end

    it 'достает сборыне изделия' do
      Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
      expect(Item.complex(parent.account_id).pluck(:id).include?(parent.id)).to eq true
    end
  end

  context 'Бесконечный цикл' do
    it 'выдает ошибку валидации при кольце' do
      Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
      i = Itemization.new(parent_id: item.id, item_id: parent.id, quantity: 1, account_id: parent.account_id)
      expect(i.valid?).to eq false
      expect(i.errors[:base]).to include('Ошибка зацикливания связей')
    end
  end
end
