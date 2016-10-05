module CoreExtensions
  module Cloudinary
    module Helpers
      def build_callback_url(options)
        options.delete(:callback_cors) || ::Cloudinary.config.callback_cors ||
          '/cloudinary_cors.html'
      end
    end
  end
end
