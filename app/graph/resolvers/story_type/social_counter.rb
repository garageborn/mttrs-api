module Resolvers
  module StoryType
    class SocialCounter < Base
      def resolve
        OpenStruct.new(
          facebook: obj.total_facebook,
          google_plus: obj.total_google_plus,
          linkedin: obj.total_linkedin,
          pinterest: obj.total_pinterest,
          total: obj.total_social,
          twitter: obj.total_twitter
        )
      end
    end
  end
end
