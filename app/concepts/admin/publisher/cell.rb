module Admin
  module Publisher
    module Cell
      class Index < Trailblazer::Cell
      end

      class Item < Trailblazer::Cell
        property :id
        property :name
        property :domain
        property :language
        property :restrict_content

        def links_count
          number_with_delimiter(model.links.size)
        end

        def today_links_count
          number_with_delimiter(model.links.today.size)
        end
      end

      class Form < Trailblazer::Cell
      end

      class UncategorizedLinks < Trailblazer::Cell
        def render
          options[:form].present? ? render_form : render_select
        end

        private

        def render_form
          options[:form].input(
            options[:name],
            as: :grouped_select,
            collection: all_publishers_options,
            group_method: :last
          )
        end

        def render_select
          prompt = options[:prompt] || 'All Publishers'
          grouped_options = grouped_options_for_select(all_publishers_options, options[:selected])
          select(options[:id], options[:name], grouped_options, prompt: prompt)
        end

        def publisher_option(publisher)
          value = options[:value] || :id
          uncategorized_links = publisher.links.available_on_current_tenant.uncategorized.distinct.size
          [
            "#{ publisher.name } (#{ number_with_delimiter(uncategorized_links) })",
            publisher.send(value)
          ]
        end

        def all_publishers_options
          with_stories = []
          without_stories = []

          ::Publisher.available_on_current_tenant.order_by_name.each do |publisher|
            option = publisher_option(publisher)
            publisher.stories.exists? ? with_stories.push(option) : without_stories.push(option)
          end

          [['With Stories', with_stories], ['Without Stories', without_stories]]
        end
      end
    end
  end
end
