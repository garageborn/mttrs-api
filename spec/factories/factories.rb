FactoryGirl.define do
  sequence :url do |n|
    "http://google.com/#{ n }"
  end

  sequence :sentence do |n|
    "#{ Faker::Lorem.sentence } #{ n }"
  end
end
