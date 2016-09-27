module Middleware
  module MaxPerforms
    autoload :Helper, './lib/middleware/max_performs/helper'
    autoload :Client, './lib/middleware/max_performs/client'
    autoload :Server, './lib/middleware/max_performs/server'
  end
end
