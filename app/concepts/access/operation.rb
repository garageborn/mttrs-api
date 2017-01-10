class Access
  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model Access
    contract Contract
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:access]) do
        contract.save
      end
    end
  end

  class DestroyAll < Operation
    def process(params)
      return if params.blank?
      params.each { |id| Destroy.run(id: id) }
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
