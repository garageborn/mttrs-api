FactoryGirl.define do
  factory :access do
    accessable { build(:link) }
    date { generate(:date) }
    hour { rand(24) }
  end
end
