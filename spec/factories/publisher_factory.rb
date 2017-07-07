FactoryGirl.define do
  factory :publisher do
    name { generate(:sentence) }
    icon_file_name { 'image.png' }
    icon_content_type { 'image' }
    icon_file_size { 1024 }
    icon_updated_at { Time.now }
  end
end
