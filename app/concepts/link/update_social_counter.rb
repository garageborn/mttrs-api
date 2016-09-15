class Link
  class UpdateSocialCounter < Operation
    action :find

    def process(params)
      return invalid! if params[:counters].blank?

      params[:counters].each { |provider, count| update_counter(provider, count) }
      social_counter.save if social_counter.increased?
    end

    private

    def social_counter
      return model.social_counters.build if last_social_counter.blank?
      model.social_counters.build(parent: last_social_counter).tap do |social_counter|
        SocialCounter::PROVIDERS.each do |provider|
          social_counter[provider] = last_social_counter.read_attribute(provider)
        end
      end
    end

    def last_social_counter
      model.social_counter
    end

    def update_counter(provider, value)
      value = value.to_i
      provider = provider.to_sym
      return if value.blank?
      return if social_counter.read_attribute(provider) > value
      social_counter[provider] = value
    end
  end
end
