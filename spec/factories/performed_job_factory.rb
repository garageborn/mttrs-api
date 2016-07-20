FactoryGirl.define do
  factory :performed_job do
    type 'MyJob'
    key { generate(:url) }
  end
end
