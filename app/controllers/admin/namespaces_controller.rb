module Admin
  class NamespacesController < ApplicationController
    def index
      present ::Namespace::Index
      render html: concept('admin/namespace/cell/index', @model)
    end

    def new
      form ::Namespace::Create
      render_form
    end

    def edit
      form ::Namespace::Update
      render_form
    end

    def create
      run ::Namespace::Create do |op|
        flash[:notice] = "Namespace '#{ op.model.url }' created"
        return redirect_to [:admin, :namespaces]
      end
      render_form
    end

    def update
      run ::Namespace::Update do |op|
        flash[:notice] = "Namespace '#{ op.model.url }' updated"
        return redirect_to [:admin, :namespaces]
      end
      render_form
    end

    def destroy
      run ::Namespace::Destroy do |op|
        flash[:notice] = "Namespace '#{ op.model.url }' destroyed"
        return redirect_to [:admin, :namespaces]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/namespace/cell/form', @form)
    end
  end
end
