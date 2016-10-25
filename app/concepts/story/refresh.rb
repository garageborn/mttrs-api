class Story
  class Refresh < Operation
    action :find

    def process(_params)
      return model.destroy unless model.reload.story_links.exists?
      update_total_social
      set_main_story_link
    end

    private

    def update_total_social
      model.update_attributes(total_social: model.links.sum(:total_social).to_i)
    end

    def set_main_story_link
      main_story_link = model.story_links.popular.first
      main_story_link.update_column(:main, true)
      model.story_links.where.not(id: main_story_link).update_all(main: false)
    end
  end
end
