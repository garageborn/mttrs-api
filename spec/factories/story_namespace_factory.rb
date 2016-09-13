FactoryGirl.define do
  factory :story_namespace do
    story
    namespace
    association :main_link, factory: :link
  end
end
