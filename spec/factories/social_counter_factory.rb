FactoryGirl.define do
  factory :social_counter do
    story
    facebook { Faker::Number.number(5).to_i }
    linkedin { Faker::Number.number(5).to_i }
  end
end
