FactoryGirl.define do
  factory :access do
    accessable { build(:link) }
  end
end
