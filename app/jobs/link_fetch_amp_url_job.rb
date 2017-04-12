class LinkFetchAmpUrlJob
  include Sidekiq::Worker

  sidekiq_options queue: :link_fetch_amp_url

  def perform(link_id)
    Link::FetchAmpUrl.run(id: link_id)
  end
end
