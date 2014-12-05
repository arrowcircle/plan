FactoryGirl.define do
  factory :account do
    name Faker::Company.name
    association :owner, factory: :user
  end
end
