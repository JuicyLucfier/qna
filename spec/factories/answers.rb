FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }

    trait :invalid do
      body { nil }
    end
  end
end
