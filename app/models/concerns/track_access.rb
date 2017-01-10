module Concerns
  module TrackAccess
    extend ActiveSupport::Concern

    included do
      has_many :accesses, as: :accessable, dependent: :destroy
    end

    def hits
      accesses.sum(:hits)
    end
  end
end
