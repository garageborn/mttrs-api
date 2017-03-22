class Notification
  class Operation < Trailblazer::Operation
    include Model
    model PublisherSuggestion
    contract Contract
  end

  class Create < Operation
    def process(params)
      validate(params[:notification]) do
        contract.save
      end
    end

    def model!(params)
      link_id =
      if params[:notification].try(:link_id).present?
        LinkNotification.new(params)
      else
        Notification.new(params)
      end
    end
  end
end
