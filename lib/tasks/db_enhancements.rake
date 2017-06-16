####### Important information ####################
# This file is used to setup a shared extensions #
# within a dedicated schema. This gives us the   #
# advantage of only needing to enable extensions #
# in one place.                                  #
#                                                #
# This task should be run AFTER db:create but    #
# BEFORE db:migrate.                             #
##################################################

namespace :db do
  desc 'Also create shared_extensions Schema'
  task extensions: :environment do
    extensions = %w[citext unaccent]
    # Create Schema
    ActiveRecord::Base.connection.execute(
      'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
    )
    # Enable extensions
    ActiveRecord::Base.connection.execute(
      extensions.map do |extension|
        "CREATE EXTENSION IF NOT EXISTS #{ extension } SCHEMA shared_extensions;"
      end.join
    )
  end
end

Rake::Task['db:create'].enhance do
  Rake::Task['db:extensions'].invoke
end

Rake::Task['db:test:purge'].enhance do
  Rake::Task['db:extensions'].invoke
end
