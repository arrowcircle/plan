FactoryGirl.define do
  factory :item do
    name { Faker::Company.name }

    factory :root do
      after(:create) do |root|
        p1 = create(:item, name: :p1)
        s1 = create(:item, name: :s1)
        s2 = create(:item, name: :s2)
        p2 = create(:item, name: :p2)
        Itemization.create(parent_id: root.id, item_id: p1.id, quantity: 2)
        Itemization.create(parent_id: root.id, item_id: p2.id, quantity: 1)
        Itemization.create(parent_id: p1.id, item_id: s1.id, quantity: 1)
        Itemization.create(parent_id: p1.id, item_id: s2.id, quantity: 2)
      end
    end
  end
end