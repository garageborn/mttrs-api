class Link
  class StoryBuilder < Operation
    extend Memoist

    action :find

    def process(_params)
      return unless model.missing_story?

      model.update_attributes(story: story)
      similar.each do |link|
        next unless link.missing_story?
        link.update_attributes(story: story)
      end

      invalid! if model.missing_story?
    end

    private

    def similar
      model.similar.records.to_a
    end

    def story
      return Story.new if similar.blank?
      similar.detect { |link| link.story.present? }.try(:story) || Story.new
    end

    memoize :similar, :story
  end
end
