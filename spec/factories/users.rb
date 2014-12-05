FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123123aA'
    created_at { Time.now }

    factory :user_with_account do
      after(:create) do |user|
        acc = create(:account, owner_id: user.id)
        AccountUser.create(account_id: acc.id, user_id: user.id)
      end
    end
  end
end
