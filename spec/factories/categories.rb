FactoryGirl.define do
  factory :category do
    name { Faker::Product.product_name }
    account

    factory :complex_category, class: Category::Complex do
    end
  end
end
