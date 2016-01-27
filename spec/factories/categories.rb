FactoryGirl.define do
  factory :category do
    name { FFaker::Product.product_name }
    account

    factory :complex_category, class: Category::Complex do
    end
  end
end
