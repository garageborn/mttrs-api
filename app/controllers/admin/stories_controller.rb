module Admin
  class StoriesController < ApplicationController
    def index
      present ::Story::Index
      render html: concept('admin/story/cell/index', @model)
    end
  end
end
