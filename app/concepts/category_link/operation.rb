class CategoryLink
  class Operation < Trailblazer::Operation
    include Model
    model CategoryLink
    contract Contract
  end

  class Destroy < Operation
    action :find

    def process(*)
      model.destroy
    end
  end
end
