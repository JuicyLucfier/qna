FactoryBot.define do
  factory :comment do
    body {"Test comment"}

    trait :invalid do
      body { nil }
    end
  end
end
