class PublisherSuggestion
  class IncrementCount < Operation
    def process(_params)
      model.increment(:count)
      model.save
    end

    def model!(params)
      publisher_suggestion_id = params[:publisher_suggestion][:id]
      publisher_suggestion_name = params[:publisher_suggestion][:name]

      return PublisherSuggestion.find(publisher_suggestion_id) if publisher_suggestion_id.present?
      PublisherSuggestion.where(name: publisher_suggestion_name).first_or_create
    end
  end
end
