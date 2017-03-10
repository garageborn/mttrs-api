class Link
  class UpdateTotalSocial < Operation
    action :find

    def process(params)
      return invalid! if params[:total_social].blank?
      model.update_attributes(total_social: params[:total_social].to_i)
      callback!(:after_update)
    end

    def model!(params)
      return params[:model] if params[:model].present?
      super(params)
    end
  end
end
