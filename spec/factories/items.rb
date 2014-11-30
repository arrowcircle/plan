FactoryGirl.define do
  factory :item do
    name { Faker::Product.product_name }
    articul { Faker::Product.model }
    account

    factory :root do
      after(:create) do |root|
        p1 = create(:item, name: :p1, account_id: root.account_id)
        s1 = create(:item, name: :s1, account_id: root.account_id)
        s2 = create(:item, name: :s2, account_id: root.account_id)
        p2 = create(:item, name: :p2, account_id: root.account_id)
        Itemization.create(parent_id: root.id, item_id: p1.id, quantity: 2, account_id: root.account_id)
        Itemization.create(parent_id: root.id, item_id: p2.id, quantity: 1, account_id: root.account_id)
        Itemization.create(parent_id: p1.id, item_id: s1.id, quantity: 1, account_id: root.account_id)
        Itemization.create(parent_id: p1.id, item_id: s2.id, quantity: 2, account_id: root.account_id)
      end
    end
  end
end