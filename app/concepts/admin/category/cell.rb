module Admin
  module Category
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        property :name
      end

      class Form < Trailblazer::Cell
      end
    end
  end
end
