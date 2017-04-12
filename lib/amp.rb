require 'google/apis/acceleratedmobilepageurl_v1'

module Amp
  class << self
    Acceleratedmobilepageurl = Google::Apis::AcceleratedmobilepageurlV1 # Alias the module

    def fetch(urls)
      service = Acceleratedmobilepageurl::AcceleratedmobilepageurlService.new
      request = Acceleratedmobilepageurl::BatchGetAmpUrlsRequest.new(urls: urls)
      service.key = ENV['GOOGLE_PRIVATE_KEY']
      service.batch_get_amp_urls(request)
    end
  end
end
