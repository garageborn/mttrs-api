class Access
  class Create < Operation
    MAX_RETRIES = 3

    def process(params)
      validate(params[:access]) do
        save
      end
    end

    def save
      with_retries(max_tries: MAX_RETRIES, rescue: ActiveRecord::RecordNotUnique) do
        access = find_or_initialize(access_params)
        access.with_lock do
          if access_params[:hits]
            access.hits = access_params[:hits]
          elsif !access.new_record?
            access.increment(:hits)
          end
          access.save
        end
      end
    end

    def params!(params)
      params[:access] ||= {}
      params[:access][:date] ||= Time.now.utc.at_beginning_of_hour
      params
    end

    private

    def find_or_initialize(params)
      Access.where(
        accessable_type: params[:accessable_type],
        accessable_id: params[:accessable_id],
        date: params[:date]
      ).first_or_initialize
    end

    def access_params
      @params[:access]
    end
  end
end
