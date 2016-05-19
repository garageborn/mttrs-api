FactoryGirl.define do
  factory :story do
    publisher
    title { Faker::Lorem.sentence }
    source_url { generate(:url) }

    after(:build) { |domain| domain.class.skip_callback(:commit, :after, :instrument_creation) }
  end
end
