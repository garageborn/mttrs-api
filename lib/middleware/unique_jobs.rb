module Middleware
  module UniqueJobs
    autoload :Client, './lib/middleware/unique_jobs/client'
    autoload :Server, './lib/middleware/unique_jobs/server'
  end
end
