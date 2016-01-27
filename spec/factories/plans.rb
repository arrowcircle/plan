FactoryGirl.define do
  factory :plan do
    name { FFaker::Product.product_name }
    account
  end
end
