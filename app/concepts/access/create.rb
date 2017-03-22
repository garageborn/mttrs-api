class Access
  class Create < Operation
    def process(params)
      validate(params[:access]) do
        model.new_record? ? create(model) : update(model)
      end
    end

    def model!(params)
      find_or_initialize(params[:access])
    end

    def params!(params)
      access_params = params[:access]
      access_params[:date] ||= Time.now.utc.at_beginning_of_hour
      params
    end

    private

    def find_or_initialize(params)
      Access.where(
        accessable_type: params[:accessable_type],
        accessable_id: params[:accessable_id],
        date: params[:date]
      ).first_or_initialize.tap do |access|
        access.hits = params[:hits] if params[:hits].present?
      end
    end

    def create(access)
      access.save
    rescue ActiveRecord::RecordNotUnique
      existing_model = find_or_initialize(@params)
      update(existing_model)
    end

    def update(access)
      if @params[:access][:hits]
        access.update_attributes(:hits, @params[:access][:hits])
      else
        access.increment!(:hits)
      end
    end
  end
end
