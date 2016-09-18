Apartment.tenant_names.each do |tenant|
  Apartment::Tenant.create(tenant)
end

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

Apartment::Tenant.switch(:mttrs_us) do
  technology = Category.find_or_create_by(name: 'Technology')
  humor = Category.find_or_create_by(name: 'Humor')

  technology.feeds << tech_crunch.feeds.first
  humor.feeds << buzz_feed.feeds.first
end

Apartment::Tenant.switch(:mttrs_br) do
  humor = Category.find_or_create_by(name: 'Diversão')
  humor.feeds << buzz_feed.feeds.last
end
