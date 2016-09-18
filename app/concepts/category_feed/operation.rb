class CategoryFeed
  class Operation < Trailblazer::Operation
    include Model
    model CategoryFeed
    contract Contract
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
