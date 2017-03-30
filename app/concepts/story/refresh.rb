class Story
  class Refresh < Operation
    action :find
    extend Memoist

    def process(_params)
      model.with_lock do
        return model.destroy unless model.story_links.exists?
        update_total_social
        set_main_story_link
      end
    end

    private

    def update_total_social
      model.update_attributes(total_social: model.links.sum(:total_social).to_i)
    end

    def set_main_story_link
      main_story_link.update_attributes(main: true)
      model.story_links.where.not(id: main_story_link).each do |story_link|
        story_link.update_attributes(main: false)
      end
    end

    def main_story_link
      model.story_links.unrestrict_content.popular.first || model.story_links.popular.first
    end

    memoize :main_story_link
  end
end
