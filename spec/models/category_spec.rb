require 'rails_helper'

describe Category do
  let(:category) { create(:category) }

  it 'не удаляет родительскую категорию' do
    child = create(:category, parent_id: category.id)
    expect(category.destroy).to eq false
    expect(category.errors.full_messages.first).to eq 'Невозможно удалить корневую категорию с наследниками'
  end

  describe Category::Complex do
    let(:category) { create(:complex_category) }
    it 'при сохранении изделия ставит номер изделия из артикула' do
      product = build(:item, articul: 'abc123.342-33 22')
      product.category = category
      product.save
      expect(product.position).to eq 1233423322
    end
  end
end
