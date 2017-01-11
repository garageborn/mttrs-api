FactoryGirl.define do
  factory :access do
    accessable { build(:link) }
    date { generate(:datetime) }
  end
end
