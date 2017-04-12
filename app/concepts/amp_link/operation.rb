class AmpLink
  class Operation < Trailblazer::Operation
    include Model
    model AmpLink
    contract Contract
  end

  class Create < Operation
    action :create

    def process(params)
      validate(params[:amp_link]) do
        contract.save
      end
    end
  end

  class Update < Operation
    action :update

    def process(params)
      validate(params[:amp_link]) do
        contract.save
      end
    end
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
