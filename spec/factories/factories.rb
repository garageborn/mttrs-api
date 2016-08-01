FactoryGirl.define do
  sequence :url do |n|
    "http://google.com/#{ n }"
  end

  sequence :sentence do |n|
    "#{ Faker::Lorem.sentence } #{ n }"
  end

  sequence :ip do |n|
    (1..4).map { n }.join('.')
  end
end
