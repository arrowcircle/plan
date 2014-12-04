FactoryGirl.define do
  factory :invite do
    account
    email Faker::Internet.email
  end
end
