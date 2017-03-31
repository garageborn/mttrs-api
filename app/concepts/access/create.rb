class Access
  class Create < Operation
    MAX_RETRIES = 3

    def process(params)
      with_retries(max_tries: MAX_RETRIES, rescue: ActiveRecord::RecordNotUnique) do
        validate(params[:access]) do
          save
        end
      end
    end

    def model!(params)
      Access.where(
        accessable_type: params[:access][:accessable_type],
        accessable_id: params[:access][:accessable_id],
        date: params[:access][:date]
      ).first_or_initialize
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
  end
end
