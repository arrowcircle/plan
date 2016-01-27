FactoryGirl.define do
  factory :account do
    name FFaker::Company.name
    association :owner, factory: :user
  end
end
