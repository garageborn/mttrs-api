module Admin
  class LinksController < BaseController
    def index
      present ::Link::Index
      render html: concept('admin/link/cell/index', @model)
    end

    def new
      form ::Link::Create
      render_form
    end

    def edit
      form ::Link::Update
      render_form
    end

    def create
      run ::Link::Create do |op|
        flash[:notice] = "Link '#{ op.model.title }' created"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    def update
      run ::Link::Update do |op|
        flash[:notice] = "Link '#{ op.model.title }' updated"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    def destroy
      run ::Link::Destroy do |op|
        flash[:notice] = "Link '#{ op.model.title }' destroyed"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    def uncategorized
      present ::Link::Uncategorized
      render html: concept('admin/link/cell/uncategorized', @model)
    end

    def similar
      present ::Link::Similar
      render html: concept('admin/link/cell/similar', @model)
    end

    def remove_from_story
      run ::Link::RemoveFromStory do |op|
        flash[:notice] = "Link '#{ op.model.title }' removed from story"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/link/cell/form', @form)
    end
  end
end
