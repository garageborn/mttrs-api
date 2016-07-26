require 'reform/form/validation/unique_validator'

class Category
  class Index < Trailblazer::Operation
    include Collection

    def model!(params)
      ::Category.filter(params)
    end

    def params!(params)
      params.permit(:page).reverse_merge(page: 1, per: 10)
    end
  end

  class Form < Trailblazer::Operation
    include Model
    model Category

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
    model Category, :find

    def process(*)
      model.destroy
      model.links.clear
    end
  end
end
