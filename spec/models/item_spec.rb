require 'rails_helper'

describe Item do
  let(:root) { create(:root) }
  let(:item) { create(:item, account_id: root.account_id) }
  let(:parent) { create(:item, account_id: root.account_id) }
  let(:subitem) { create(:item, account_id: root.account_id) }

  it 'возвращает пустой массиов для пустого дерева' do
    expect(parent.tree).to eq Hash.new
  end

  it 'возвращает плоский массив для 2х элементов' do
    parent; item; subitem
    i1 = Itemization.create(parent_id: parent.id, item_id: item.id, quantity: 1, account_id: parent.account_id)
    i2 = Itemization.create(parent_id: parent.id, item_id: subitem.id, quantity: 2, account_id: parent.account_id)
    expect(parent.tree.keys).to eq [1, 2]
  end

  it 'выводит список компонентов для корня' do
    expect(root.tree.keys).to eq [2, 4, 1]
  end
end
