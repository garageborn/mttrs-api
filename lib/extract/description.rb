class Extract
  class Description < Base
    def value
      meta_description || matcher_value(:description)
    end

    private

    def meta_description
      meta_value("property='og:description'") || meta_value("name='description'")
    end
  end
end
