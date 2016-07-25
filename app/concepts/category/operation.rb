require 'reform/form/validation/unique_validator'

class Category
  class Index < Trailblazer::Operation
    include Collection

    def model!(_params)
      ::Category.all.limit(10)
    end
  end

  class Create < Trailblazer::Operation
    include Model
    model Category, :create

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

  class Update < Create
    action :update
  end

  class Destroy < Trailblazer::Operation
    include Model
    model Category, :find

    def process(params)
      model.destroy
      model.links.clear
    end
  end
end
