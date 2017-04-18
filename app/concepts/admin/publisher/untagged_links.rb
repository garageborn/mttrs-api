module Admin
  module Publisher
    module Cell
      class UntaggedLinks < Trailblazer::Cell
        extend Memoist

        def render
          prompt = options[:prompt] || 'All Publishers'
          grouped_options = grouped_options_for_select(all_publishers_options, options[:selected])
          select(options[:id], options[:name], grouped_options, prompt: prompt)
        end

        def publisher_option(publisher)
          value = options[:value] || :id
          untagged_links = untagged_links_count(publisher)
          [
            "#{ publisher.name } (#{ number_with_delimiter(untagged_links) })",
            publisher.send(value)
          ]
        end

        def all_publishers_options
          with_tags = []
          without_tags = []

          ::Publisher.available_on_current_tenant.order_by_name.each do |publisher|
            option = publisher_option(publisher)
            untagged_links_count(publisher) > 0 ? without_tags.push(option) : with_tags.push(option)
          end

          [['Without Tags', without_tags], ['With Tags', with_tags]]
        end

        def untagged_links_count(publisher)
          publisher.links.available_on_current_tenant.untagged.distinct.size
        end

        memoize :untagged_links_count
      end
    end
  end
end
