module Admin
  class TagsController < BaseController
    def index
      present ::Tag::Index
      render html: concept('admin/tag/cell/index', @model)
    end

    def new
      form ::Tag::Create
      render_form
    end

    def edit
      form ::Tag::Update
      render_form
    end

    def create
      run ::Tag::Create do |op|
        flash[:notice] = "Tag '#{ op.model.name }' created"
        return redirect_to %i[admin tags]
      end
      render_form
    end

    def update
      run ::Tag::Update do |op|
        flash[:notice] = "Tag '#{ op.model.name }' updated"
        return redirect_to %i[admin tags]
      end
      render_form
    end

    def destroy
      run ::Tag::Destroy do |op|
        flash[:notice] = "Tag '#{ op.model.name }' destroyed"
        return redirect_to %i[admin tags]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/tag/cell/form', @form)
    end
  end
end
