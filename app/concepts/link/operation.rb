require 'reform/form/validation/unique_validator'

class Link
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 30, recent: true }.freeze

    def model!(params)
      ::Link.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page))
    end
  end

  class Form < Trailblazer::Operation
    include Model
    model Link

    contract do
      property :name
      validates :name, presence: true, unique: { case_sensitive: false }
    end

    def process(params)
      validate(params[:category]) do
        contract.save
      end
    end
  end

  class Create < Form
    action :create
  end

  class Update < Create
    action :update
  end

  class Destroy < Trailblazer::Operation
    include Model
    model Link, :find

    def process(*)
      model.destroy
      model.links.clear
    end
  end
end
