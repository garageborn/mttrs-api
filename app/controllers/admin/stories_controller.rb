module Admin
  class StoriesController < BaseController
    def index
      present ::Story::Index
      render html: concept('admin/story/cell/index', @model)
    end

    def edit
      form ::Story::Update
      render_form
    end

    def update
      run ::Story::Update do |op|
        flash[:notice] = "Story '#{ op.model.id }' updated"
        return redirect_to %i[admin stories]
      end
      render_form
    end

    def destroy
      run ::Story::Destroy do |op|
        flash[:notice] = "Story '#{ op.model.id }' destroyed"
        return redirect_to %i[admin stories]
      end
      render_form
    end

    def similar_links
      present ::Story::SimilarLinks
      render html: concept('admin/story/cell/similar_links', @model, layout: false)
    end

    private

    def render_form
      render html: concept('admin/story/cell/form', @form)
    end
  end
end
