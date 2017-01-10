class Access
  class Create < Operation
    def process(params)
      validate(params[:access]) do
        model.new_record? ? create : increment_hits!(model)
      end
    end

    def model!(params)
      find_or_initialize(params[:access])
    end

    def params!(params)
      access_params = params[:access]
      access_params[:date] = Time.now.utc.at_beginning_of_hour
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

    def create
      begin
        contract.save
      rescue ActiveRecord::RecordNotUnique
        existing_model = find_or_initialize(params)
        increment_hits!(existing_model)
      end
    end

    def increment_hits!(model)
      Access.increment_counter(:hits, model.id)
    end
  end
end
