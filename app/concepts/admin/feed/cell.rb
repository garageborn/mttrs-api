module Admin
  module Feed
    module Cell
      class Index < Trailblazer::Cell
        include Kaminari::Cells
      end

      class Item < Trailblazer::Cell
        include ActionView::Helpers::NumberHelper
        property :url

        def links_count
          number_with_delimiter(model.links.size)
        end

        def today_links_count
          number_with_delimiter(model.links.today.size)
        end

        def yesterday_links_count
          number_with_delimiter(model.links.yesterday.size)
        end

        def last_week_links_count
          number_with_delimiter(model.links.last_week.size)
        end

        def last_month_links_count
          number_with_delimiter(model.links.last_month.size)
        end
      end

      class Form < Trailblazer::Cell
        include ActionView::Helpers::FormOptionsHelper
      end
    end
  end
end
