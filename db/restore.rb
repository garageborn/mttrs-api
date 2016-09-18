# past slowly
Publisher.create([
  { id: 1, name: 'CNN', slug: 'cnn', domain: 'cnn.com' },
  { id: 3, name: 'Forbes', slug: 'forbes', domain: 'forbes.com' },
  { id: 4, name: 'Mashable', slug: 'mashable', domain: 'mashable.com' },
  { id: 5, name: 'BuzzFeed', slug: 'buzzfeed', domain: 'buzzfeed.com' },
  { id: 6, name: 'Popular Science', slug: 'popular-science', domain: 'popsci.com' },
  { id: 8, name: 'New York Times', slug: 'new-york-times', domain: 'nytimes.com' },
  { id: 9, name: 'The Guardian', slug: 'the-guardian', domain: 'theguardian.com' },
  { id: 10, name: 'ABC News', slug: 'abc-news', domain: 'abcnews.com' },
  { id: 11, name: 'Reuters', slug: 'reuters', domain: 'reuters.com' },
  { id: 13, name: 'Recode', slug: 'recode', domain: 'recode.net' },
  { id: 14, name: 'The Verge', slug: 'the-verge', domain: 'theverge.com' },
  { id: 15, name: 'Ars Technica', slug: 'ars-technica', domain: 'arstechnica.com' },
  { id: 16, name: 'Wired', slug: 'wired', domain: 'wired.com' },
  { id: 17, name: 'Huffington Post', slug: 'huffington-post', domain: 'huffingtonpost.com' },
  { id: 18, name: 'E Online', slug: 'e-online', domain: 'eonline.com' },
  { id: 19, name: 'TMZ', slug: 'tmz', domain: 'tmz.com' },
  { id: 20, name: 'CBS', slug: 'cbs', domain: 'cbsnews.com' },
  { id: 21, name: 'The Onion', slug: 'the-onion', domain: 'theonion.com' },
  { id: 22, name: 'College Humor', slug: 'college-humor', domain: 'collegehumor.com' },
  { id: 24, name: 'Bored Panda', slug: 'bored-panda', domain: 'boredpanda.com' },
  { id: 26, name: 'ClickHole', slug: 'clickhole', domain: 'clickhole.com' },
  { id: 27, name: 'Science Daily', slug: 'science-daily', domain: 'sciencedaily.com' },
  { id: 25, name: 'theCHIVE', slug: 'thechive', domain: 'thechive.com' },
  { id: 23, name: 'Cracked', slug: 'cracked', domain: 'cracked.com' },
  { id: 12, name: 'The Next Web', slug: 'the-next-web', domain: 'thenextweb.com' },
  { id: 2, name: 'TechCrunch', slug: 'techcrunch', domain: 'techcrunch.com' },
  { id: 7, name: 'BBC', slug: 'bbc', domain: 'bbc.co.uk' },
  { id: 28, name: 'Quartz', slug: 'quartz', domain: 'qz.com' },
  { id: 29, name: 'Vox', slug: 'vox', domain: 'vox.com' },
  { id: 30, name: 'GameSpot', slug: 'gamespot', domain: 'gamespot.com' },
  { id: 31, name: 'Polygon', slug: 'polygon', domain: 'polygon.com' },
  { id: 32, name: 'Bleacher Report', slug: 'bleacher-report', domain: 'bleacherreport.com' },
  { id: 33, name: 'ESPN', slug: 'espn', domain: 'espn.com' },
  { id: 34, name: 'FOX News', slug: 'fox-news', domain: 'foxnews.com' }
])

Feed.create([
  { id: 1, publisher_id: 1, language: 'en', url: 'http://rss.cnn.com/rss/edition.rss' },
  { id: 2, publisher_id: 2, language: 'en', url: 'http://feeds.feedburner.com/TechCrunch/startups' },
  { id: 3, publisher_id: 3, language: 'en', url: 'http://www.forbes.com/business/feed2/' },
  { id: 4, publisher_id: 4, language: 'en', url: 'http://feeds.mashable.com/mashable/tech' },
  { id: 5, publisher_id: 4, language: 'en', url: 'http://feeds.mashable.com/mashable/business' },
  { id: 6, publisher_id: 4, language: 'en', url: 'http://feeds.mashable.com/mashable/entertainment' },
  { id: 7, publisher_id: 5, language: 'en', url: 'https://www.buzzfeed.com/index.xml' },
  { id: 8, publisher_id: 6, language: 'en', url: 'http://www.popsci.com/rss.xml' },
  { id: 9, publisher_id: 7, language: 'en', url: 'http://feeds.bbci.co.uk/news/world/rss.xml' },
  { id: 10, publisher_id: 8, language: 'en', url: 'http://rss.nytimes.com/services/xml/rss/nyt/World.xml' },
  { id: 11, publisher_id: 9, language: 'en', url: 'http://www.theguardian.com/world/rss' },
  { id: 12, publisher_id: 10, language: 'en', url: 'http://feeds.abcnews.com/abcnews/internationalheadlines' },
  { id: 13, publisher_id: 11, language: 'en', url: 'http://feeds.reuters.com/Reuters/worldNews' },
  { id: 14, publisher_id: 7, language: 'en', url: 'http://feeds.bbci.co.uk/news/business/rss.xml' },
  { id: 15, publisher_id: 8, language: 'en', url: 'http://rss.nytimes.com/services/xml/rss/nyt/Business.xml' },
  { id: 16, publisher_id: 11, language: 'en', url: 'http://feeds.reuters.com/reuters/businessNews' },
  { id: 17, publisher_id: 2, language: 'en', url: 'http://feeds.feedburner.com/TechCrunch/' },
  { id: 18, publisher_id: 12, language: 'en', url: 'http://feeds2.feedburner.com/thenextweb' },
  { id: 19, publisher_id: 13, language: 'en', url: 'http://www.recode.net/rss/index.xml' },
  { id: 20, publisher_id: 14, language: 'en', url: 'http://www.theverge.com/rss/frontpage' },
  { id: 21, publisher_id: 15, language: 'en', url: 'http://feeds.arstechnica.com/arstechnica/index/' },
  { id: 22, publisher_id: 16, language: 'en', url: 'http://www.wired.com/feed/' },
  { id: 23, publisher_id: 17, language: 'en', url: 'http://www.huffingtonpost.com/feeds/verticals/entertainment/index.xml' },
  { id: 24, publisher_id: 18, language: 'en', url: 'http://syndication.eonline.com/syndication/feeds/rssfeeds/topstories.xml' },
  { id: 25, publisher_id: 19, language: 'en', url: 'http://www.tmz.com/rss.xml' },
  { id: 26, publisher_id: 7, language: 'en', url: 'http://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml' },
  { id: 27, publisher_id: 20, language: 'en', url: 'http://www.cbsnews.com/latest/rss/entertainment' },
  { id: 28, publisher_id: 21, language: 'en', url: 'http://www.theonion.com/feeds/rss' },
  { id: 30, publisher_id: 22, language: 'en', url: 'http://www.collegehumor.com/rss' },
  { id: 31, publisher_id: 23, language: 'en', url: 'http://feeds.feedburner.com/CrackedRSS' },
  { id: 32, publisher_id: 24, language: 'en', url: 'http://www.boredpanda.com/feed/' },
  { id: 33, publisher_id: 25, language: 'en', url: 'http://feeds.feedburner.com/feedburner/ZdSV' },
  { id: 34, publisher_id: 26, language: 'en', url: 'http://www.clickhole.com/feeds/rss' },
  { id: 35, publisher_id: 7, language: 'en', url: 'http://feeds.bbci.co.uk/news/science_and_environment/rss.xml' },
  { id: 36, publisher_id: 27, language: 'en', url: 'https://rss.sciencedaily.com/top.xml' },
  { id: 37, publisher_id: 11, language: 'en', url: 'http://feeds.reuters.com/reuters/scienceNews' },
  { id: 38, publisher_id: 8, language: 'en', url: 'http://rss.nytimes.com/services/xml/rss/nyt/Science.xml' },
  { id: 29, publisher_id: 17, language: 'en', url: 'http://www.huffingtonpost.com/feeds/verticals/comedy/index.xml' },
  { id: 39, publisher_id: 28, language: 'en', url: 'http://qz.com/feed/' },
  { id: 40, publisher_id: 29, language: 'en', url: 'http://www.vox.com/rss/index.xml' },
  { id: 41, publisher_id: 30, language: 'en', url: 'http://www.gamespot.com/feeds/news/' },
  { id: 42, publisher_id: 31, language: 'en', url: 'http://www.polygon.com/rss/index.xml' },
  { id: 43, publisher_id: 32, language: 'en', url: 'http://bleacherreport.com/articles/feed' },
  { id: 44, publisher_id: 33, language: 'en', url: 'http://www.espn.com/espn/rss/news' },
  { id: 45, publisher_id: 34, language: 'en', url: 'http://feeds.foxnews.com/foxnews/sports' },
  { id: 46, publisher_id: 34, language: 'en', url: 'http://feeds.foxnews.com/foxnews/world' },
  { id: 47, publisher_id: 34, language: 'en', url: 'http://feeds.foxnews.com/foxnews/entertainment' },
  { id: 48, publisher_id: 5, language: 'pt', url: 'https://www.buzzfeed.com/index.xml?country=pt-br' }
])


Apartment::Tenant.switch(:mttrs_us) do
  Category.create([
    { id: 1, name: 'World News', feed_ids: [1, 9, 10, 11, 12, 13, 39, 40, 46] },
    { id: 2, name: 'Business', feed_ids: [2, 3, 5, 14, 15, 16] },
    { id: 3, name: 'Technology', feed_ids: [4, 17, 18, 19, 20, 21, 22] },
    { id: 4, name: 'Entertainment', feed_ids: [6, 23, 24, 25, 26, 27, 47] },
    { id: 5, name: 'Humor', feed_ids: [7, 28, 30, 31, 32, 33, 34, 29] },
    { id: 6, name: 'Science', feed_ids: [8, 35, 36, 37, 38] },
    { id: 7, name: 'Gaming', feed_ids: [41, 42] },
    { id: 8, name: 'Sports', feed_ids: [43, 44, 45] }
  ])

  CategoryMatcher.create([
    { publisher_id: 15, category_id: 2, url_matcher: '/business/\\d{4}/\\d{2}/', order: 0 },
    { publisher_id: 15, category_id: 3, url_matcher: '/information-technology/\\d{4}/\\d{2}/', order: 0 },
    { publisher_id: 15, category_id: 6, url_matcher: '/science/\\d{4}/\\d{2}/', order: 0 },
    { publisher_id: 7, category_id: 4, url_matcher: '/entertainment-arts-\\d+', order: 0 },
    { publisher_id: 7, category_id: 2, url_matcher: '/business-\\d+', order: 0 },
    { publisher_id: 7, category_id: 1, url_matcher: '/news/world-', order: 0 },
    { publisher_id: 1, category_id: 4, url_matcher: '/entertainment/\\d{4}/\\d{2}/\\d{2}', order: 0 },
    { publisher_id: 1, category_id: 4, url_matcher: '\\d{4}/\\d{2}/\\d{2}/entertainment/', order: 0 },
    { publisher_id: 1, category_id: 2, url_matcher: '/business/\\d{4}/\\d{2}/\\d{2}', order: 0 },
    { publisher_id: 1, category_id: 2, url_matcher: '\\d{4}/\\d{2}/\\d{2}/smallbusiness/', order: 0 },
    { publisher_id: 1, category_id: 3, url_matcher: '/technology/\\d{4}/\\d{2}/\\d{2}', order: 0 },
    { publisher_id: 1, category_id: 3, url_matcher: '\\d{4}/\\d{2}/\\d{2}/technology/', order: 0 },
    { publisher_id: 1, category_id: 3, url_matcher: 'cnn.com/technology/', order: 0 },
    { publisher_id: 1, category_id: 3, url_matcher: 'cnn.com/interactive/technology/', order: 0 },
    { publisher_id: 1, category_id: 1, url_matcher: '/world/\\d{4}/\\d{2}/\\d{2}', order: 0 },
    { publisher_id: 22, category_id: 5, url_matcher: '(.*)', order: 0 },
    { publisher_id: 8, category_id: 4, url_matcher: '\\d{4}/\\d{2}/\\d{2}/(.*)/entertainment/', order: 0 },
    { publisher_id: 8, category_id: 2, url_matcher: '\\d{4}/\\d{2}/\\d{2}/business/', order: 0 },
    { publisher_id: 8, category_id: 6, url_matcher: '\\d{4}/\\d{2}/\\d{2}/science/', order: 0 },
    { publisher_id: 8, category_id: 1, url_matcher: '\\d{4}/\\d{2}/\\d{2}/world/', order: 0 },
    { publisher_id: 6, category_id: 3, url_matcher: '/technology/article/\\d{4}-\\d{2}/', order: 0 },
    { publisher_id: 6, category_id: 6, url_matcher: '/science/article/\\d{4}-\\d{2}/', order: 0 },
    { publisher_id: 9, category_id: 2, url_matcher: '/business/\\d{4}/', order: 0 },
    { publisher_id: 9, category_id: 2, url_matcher: '/sustainable-business/\\d{4}/', order: 0 },
    { publisher_id: 9, category_id: 3, url_matcher: '/technology/\\d{4}/', order: 0 },
    { publisher_id: 9, category_id: 6, url_matcher: '/science/\\d{4}/', order: 0 },
    { publisher_id: 9, category_id: 6, url_matcher: 'www.theguardian.com/science/', order: 0 },
    { publisher_id: 9, category_id: 1, url_matcher: '/world/\\d{4}/', order: 0 }
  ])
end

Apartment::Tenant.switch(:mttrs_br) do
  Category.create([
    { id: 5, name: 'Humor', feed_ids: [48] }
  ])
end
