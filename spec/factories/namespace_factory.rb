FactoryGirl.define do
  factory :namespace do
    sequence(:slug) { |n| "namespace_#{ n }" }
  end
end
