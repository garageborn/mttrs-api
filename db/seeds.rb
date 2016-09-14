Apartment::Tenant.create(:default)
Apartment::Tenant.create(:mttrs_br)

tech_crunch = Publisher.create(
  name: 'TechCrunch',
  domain: 'techcrunch.com',
  feeds: [
    Feed.new(url: 'http://feeds.feedburner.com/TechCrunch/startups')
  ]
)
buzz_feed = Publisher.create(
  name: 'BuzzFeed',
  domain: 'buzzfeed.com',
  feeds: [
    Feed.new(url: 'https://www.buzzfeed.com/index.xml'),
    Feed.new(url: 'https://www.buzzfeed.com/index.xml?country=pt-br', language: 'pt')
  ]
)

Apartment::Tenant.switch(:default) do
  technology = Category.find_or_create_by(name: 'Technology')
  humor = Category.find_or_create_by(name: 'Humor')
end

Apartment::Tenant.switch(:mttrs_br) do
  humor = Category.find_or_create_by(name: 'Diversão')
end
