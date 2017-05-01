module Resolvers
  module StoryType
    class SocialCounter < Base
      def resolve
        OpenStruct.new(
          facebook: obj.total_facebook,
          twitter: obj.total_twitter,
          pinterest: obj.total_pinterest,
          google_plus: obj.total_google_plus,
          total: obj.total_social
        )
      end
    end
  end
end
