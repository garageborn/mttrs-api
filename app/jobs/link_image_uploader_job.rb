class LinkImageUploaderJob
  include Sidekiq::Worker
  extend Memoist

  sidekiq_options queue: :link_image_uploader, retry: false
  attr_reader :link_id

  def perform(link_id)
    @link_id = link_id
    return if link.blank? || link.image.present? || file.blank?
    link.update_attributes(image: file)
  end

  def link
    Link.find_by(id: link_id)
  end

  def file
    return if link.image_source_url.blank?
    response = Utils::UrlFetcher.run(link.image_source_url)
    return if response.blank?
    StringIO.new(response.body).tap do |string_io|
      string_io.class.class_eval { attr_accessor :original_filename }
      string_io.original_filename = link.image_source_url.split('/').last
    end
  end

  memoize :link, :file
end
