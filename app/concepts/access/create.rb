class Access
  class Create < Operation
    MAX_RETRIES = 3
    RESCUE_FROM = [
      ActiveRecord::RecordNotUnique
    ].freeze

    def process(params)
      reload_model_handler = proc { reload_model! }
      validate(params[:access]) do
        with_retries(max_tries: MAX_RETRIES, handler: reload_model_handler, rescue: RESCUE_FROM) do
          save
        end
      end
    end

    def model!(params)
      find_or_initialize(params)
    end

    def params!(params)
      params[:access] ||= {}
      params[:access][:date] ||= Time.now.utc.at_beginning_of_hour
      params
    end

    def save
      model.with_lock do
        if access_params[:hits]
          model.hits = access_params[:hits]
        elsif !model.new_record?
          model.increment(:hits)
        end
        model.save
      end
    end

    private

    def access_params
      @params[:access]
    end

    def reload_model!
      self.model = find_or_initialize(@params)
    end

    def find_or_initialize(params)
      Access.where(
        accessable_type: params[:access][:accessable_type],
        accessable_id: params[:access][:accessable_id],
        date: params[:access][:date]
      ).first_or_initialize
    end
  end
end
