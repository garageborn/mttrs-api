module Utils
  class OpenStructParser < HTTParty::Parser
    def parse
      return if body.blank?
      JSON.parse(body, object_class: OpenStruct)
    end
  end
end
