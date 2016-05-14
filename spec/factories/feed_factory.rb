FactoryGirl.define do
  factory :feed do
    publisher
    category
    url { generate(:url) }

    after(:build) { |domain| domain.class.skip_callback(:commit, :after, :instrument_creation) }
  end
end
