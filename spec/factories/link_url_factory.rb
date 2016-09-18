FactoryGirl.define do
  factory :link_url do
    link
    url { generate(:url) }
  end
end
