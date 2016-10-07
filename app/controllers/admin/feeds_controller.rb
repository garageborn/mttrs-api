module Admin
  class FeedsController < BaseController
    def index
      present ::Feed::Index
      render html: concept('admin/feed/cell/index', @model)
    end

    def new
      form ::Feed::Create
      render_form
    end

    def edit
      form ::Feed::Update
      render_form
    end

    def create
      run ::Feed::Create do |op|
        flash[:notice] = "Feed '#{ op.model.url }' created"
        return redirect_to [:admin, :feeds]
      end
      render_form
    end

    def update
      run ::Feed::Update do |op|
        flash[:notice] = "Feed '#{ op.model.url }' updated"
        return redirect_to [:admin, :feeds]
      end
      render_form
    end

    def destroy
      run ::Feed::Destroy do |op|
        flash[:notice] = "Feed '#{ op.model.url }' destroyed"
        return redirect_to [:admin, :feeds]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/feed/cell/form', @form)
    end
  end
end
