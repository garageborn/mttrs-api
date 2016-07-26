module Admin
  module Category
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Show < Trailblazer::Cell
        property :name
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
