FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }

    after(:build) { |domain| domain.class.skip_callback(:commit, :after, :instrument_creation) }
  end
end
