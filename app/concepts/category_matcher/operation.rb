require 'reform/form/validation/unique_validator'

class CategoryMatcher
  class Index < Trailblazer::Operation
    include Collection
    DEFAULT_PARAMS = { page: 1, per: 10 }.freeze

    def model!(params)
      ::CategoryMatcher.filter(params)
    end

    def params!(params)
      DEFAULT_PARAMS.merge(params.permit(:page).to_h)
    end
  end

  class Form < Trailblazer::Operation
    include Model
    model CategoryMatcher

    contract do
      include Reform::Form::ModelReflections
      property :publisher_id
      property :category_id
      property :url_matcher

      validates :publisher_id, :category_id, presence: true
      validates :url_matcher,
                unique: { case_sensitive: false, scope: :publisher_id },
                allow_blank: true

      def prepopulate!(options)
        self.publisher_id ||= options[:params][:publisher_id]
        self.category_id ||= options[:params][:category_id]
      end
    end

    def process(params)
      validate(params[:category_matcher]) do
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
    model CategoryMatcher, :find

    def process(*)
      model.destroy
    end
  end
end
