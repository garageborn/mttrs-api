FactoryGirl.define do
  sequence :ip do |n|
    (1..4).map { n }.join('.')
  end

  sequence :sentence do |n|
    "#{ Faker::Lorem.sentence } #{ n }"
  end

  sequence :domain do |n|
    "mydomain#{ n }.com"
  end

  sequence :url do |n|
    "http://google.com/#{ n }"
  end
end
