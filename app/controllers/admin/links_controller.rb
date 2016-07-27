module Admin
  class LinksController < ApplicationController
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
        flash[:notice] = "Link '#{ op.model.name }' created"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    def update
      run ::Link::Update do |op|
        flash[:notice] = "Link '#{ op.model.name }' updated"
        return redirect_to [:admin, :links]
      end
      render_form
    end

    def destroy
      run ::Link::Destroy do |op|
        flash[:notice] = "Link '#{ op.model.name }' destroyed"
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
