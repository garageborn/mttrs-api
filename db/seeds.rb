if Rails.env.development?
  technology = Category.create(name: 'Technology')
  business = Category.create(name: 'Business')
  entertainment = Category.create(name: 'Entertainment')

  Publisher.create(
    name: 'Mashable',
    feeds: [
      Feed.new(category: technology, url: 'http://feeds.mashable.com/mashable/tech'),
      Feed.new(category: business, url: 'http://feeds.mashable.com/mashable/business'),
      Feed.new(category: entertainment, url: 'http://feeds.mashable.com/mashable/entertainment')
    ]
  )

  Publisher.create(
    name: 'TechCrunch',
    feeds: [
      Feed.new(category: business, url: 'http://feeds.feedburner.com/TechCrunch/startups'),
    ]
  )
end
