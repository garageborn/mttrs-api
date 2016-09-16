class SocialCounter
  class UpdateCounters < Operation
    extend Memoist

    def process(params)
      return invalid! if link.blank? || params[:counters].blank?

      params[:counters].each { |provider, count| update_counter(provider, count) }
      return unless model.increased?
      return unless model.save
      callback!(:after_save)
    end

    private

    def link
      ::Link.find_by_id(@params[:link_id])
    end

    def model!(_params)
      return link.social_counters.build if last_social_counter.blank?
      link.social_counters.build(parent: last_social_counter).tap do |social_counter|
        SocialCounter::PROVIDERS.each do |provider|
          social_counter[provider] = last_social_counter.read_attribute(provider)
        end
      end
    end

    def last_social_counter
      link.social_counter
    end

    def update_counter(provider, value)
      value = value.to_i
      provider = provider.to_sym
      return if value.blank?
      return if model.read_attribute(provider) > value
      model[provider] = value
    end

    memoize :link
  end
end
