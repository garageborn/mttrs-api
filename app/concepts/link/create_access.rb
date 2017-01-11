class Link
  class CreateAccess < Operation
    def process(_params)
      Access::Create.run(access: { accessable_type: 'Link', accessable_id: model.id }) do |op|
        break if model.story.blank?
        UpdateStoryAccessesJob.perform_async(model.id, op.model.date)
      end
    end

    def model!(params)
      params[:model] || Link.find_by(id: params[:link][:id])
    end
  end
end
