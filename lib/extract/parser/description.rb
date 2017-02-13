module Extract
  module Parser
    class Description < Base
      def value
        meta_value("property='og:description'") || meta_value("name='description'")
      end
    end
  end
end
