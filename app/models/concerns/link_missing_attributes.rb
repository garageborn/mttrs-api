module Concerns
  module LinkMissingAttributes
    extend ActiveSupport::Concern

    def missing_html?
      html.blank?
    end

    def missing_story?
      story.blank?
    end
  end
end
