module Admin
  class FeedsController < ApplicationController
    def index
      present Feed::Index
    end
  end
end
