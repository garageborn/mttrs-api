class Link
  class UpdateTotalSocial < Operation
    action :find

    def process(params)
      return invalid! if params[:total_social].blank?
      model.update_attributes(total_social: params[:total_social].to_i)
      callback!(:after_save)
    end
  end
end
