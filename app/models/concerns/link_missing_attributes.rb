module Concerns
  module LinkMissingAttributes
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

    def missing_language?
      language.blank?
    end

    def missing_story?
      story.blank?
    end

    def missing_categories?
      categories.blank?
    end

    def needs_full_fetch?
      missing_info? || missing_image? || missing_language? || missing_html?
    end
  end
end
