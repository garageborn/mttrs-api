module SimpleForm
  module CustomInputs
    class ArrayInput < SimpleForm::Inputs::StringInput
      def input(wrapper_options = nil)
        input_html_options[:type] ||= input_type
        values = Array(object.public_send(attribute_name)).concat([nil])
        field_name = "#{ object_name }[#{ attribute_name }][]"

        values.map do |value|
          field_id = "#{ attribute_name }_#{ value }"
          @builder.text_field(field_id, input_html_options.merge(value: value, name: field_name))
        end.join.html_safe
      end

      def input_type
        :text
      end
    end
  end
end
