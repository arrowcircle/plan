FactoryGirl.define do
  factory :invite do
    account
    email FFaker::Internet.email
  end
end
