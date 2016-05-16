if Rails.env.development?
  world_news = Category.find_or_create_by(name: 'World News')
  business = Category.find_or_create_by(name: 'Business')
  technology = Category.find_or_create_by(name: 'Technology')
  entertainment = Category.find_or_create_by(name: 'Entertainment')
  humor = Category.find_or_create_by(name: 'Humor')
  science = Category.find_or_create_by(name: 'Science')

  Publisher.create(
    name: 'CNN',
    feeds: [
      Feed.new(category: world_news, url: 'http://rss.cnn.com/rss/edition.rss')
    ]
  )

  Publisher.create(
    name: 'TechCrunch',
    feeds: [
      Feed.new(category: business, url: 'http://feeds.feedburner.com/TechCrunch/startups'),
    ]
  )

  Publisher.create(
    name: 'Forbes',
    feeds: [
      Feed.new(category: business, url: 'http://www.forbes.com/business/feed2/')
    ]
  )

  Publisher.create(
    name: 'Mashable',
    feeds: [
      Feed.new(category: technology, url: 'http://feeds.mashable.com/mashable/tech'),
      Feed.new(category: business, url: 'http://feeds.mashable.com/mashable/business'),
      Feed.new(category: entertainment, url: 'http://feeds.mashable.com/mashable/entertainment')
    ]
  )

  Publisher.create(
    name: 'BuzzFeed',
    feeds: [
      Feed.new(category: humor, url: 'https://www.buzzfeed.com/index.xml'),
    ]
  )

  Publisher.create(
    name: 'Popular Science',
    feeds: [
      Feed.new(category: science, url: 'http://www.popsci.com/rss.xml'),
    ]
  )
end