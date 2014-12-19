FactoryGirl.define do
  factory :plan do
    name { Faker::Product.product_name }
    account
  end

end
