class Story
  class UpdateAccesses < Operation
    extend Memoist

    def process(params)
      return if model.blank?
      Access::Create.run(access: {
        accessable_type: 'Story',
        accessable_id: model.id,
        date: params[:date],
        hits: model.links_accesses.by_timeframe(:hour, params[:date]).hits
      })
    end

    private

    def link
      ::Link.find_by(id: @params[:link_id])
    end

    def model!(_params)
      link.story
    end

    memoize :link
  end
end
