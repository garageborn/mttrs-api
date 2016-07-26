module Admin
  class StoriesController < ApplicationController
    def index
      present Story::Index
    end
  end
end
