FactoryBot.define do
  factory :user_beer do
    association :user, factory: :user
    association :beer, factory: :beer
  end
end
