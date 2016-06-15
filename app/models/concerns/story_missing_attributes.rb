module Concerns
  module StoryMissingAttributes
    extend ActiveSupport::Concern

    def missing_info?
      title.blank? || description.blank?
    end

    def missing_image?
      image_source_url.blank?
    end

    def missing_html?
      html.blank?
    end

    def needs_full_fetch?
      missing_info? || missing_image? || missing_html?
    end
  end
end
