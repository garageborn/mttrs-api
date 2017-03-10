class Publisher
  class ApplyTitleReplacements < Operation
    action :find

    def process(*)
      return if model.title_replacements.blank? || model.links.blank?
      model.links.find_each do |link|
        new_title = model.title_replacements.apply(link.title)
        next if new_title == link.title
        link.update_attributes(title: new_title)
      end
    end
  end
end
