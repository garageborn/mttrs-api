# https://github.com/nathanvda/cocoon/issues/315
module CoreExtensions
  module Cocoon
    module ViewHelpers
      def render_association(association, f, new_object, form_name, render_options = {}, custom_partial = nil)
        partial = get_partial_path(custom_partial, association)
        locals =  render_options.delete(:locals) || {}
        ancestors = f.class.ancestors.map{|c| c.to_s}
        method_name = ancestors.include?('SimpleForm::FormBuilder') ? :simple_fields_for : (ancestors.include?('Formtastic::FormBuilder') ? :semantic_fields_for : :fields_for)
        f.send(method_name, association, new_object, { child_index: "new_#{association}" }.merge(render_options)) do |builder|
          partial_options = {form_name.to_sym => builder, :dynamic => true}.merge(locals)
          render(view: partial, locals: partial_options).html_safe
        end
      end
    end
  end
end
