namespace :seed do
  task category_matchers: :environment do
    Seeds::CategoryMatcher.run!
  end

  task feeds: :environment do
    Seeds::Feed.run!
  end
end
