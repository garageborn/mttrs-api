class Link
  class Form < Operation
    contract Contract

    def process(params)
      validate(params[:link]) do
        model.save
        callback!(:after_create) if model.previous_changes.include?(:id)
        callback!(:after_save)
      end
    end

    private

    def model!(params)
      return ::Link.find_by_id(params[:id]) if params[:id].present?
      urls = params[:link].try(:[], :urls)
      return ::Link.new(params[:link]) if urls.blank?
      ::Link.find_by_url(urls) || ::Link.new(params[:link])
    end
  end
end
