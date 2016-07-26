module Admin
  class PublishersController < ApplicationController
    def index
      present ::Publisher::Index
      render html: concept('admin/publisher/cell/index', @model)
    end

    def new
      form ::Publisher::Create
      render_form
    end

    def edit
      form ::Publisher::Update
      render_form
    end

    def create
      run ::Publisher::Create do |op|
        flash[:notice] = "Publisher '#{ op.model.name }' created"
        return redirect_to [:admin, :publishers]
      end
      render_form
    end

    def update
      run ::Publisher::Update do |op|
        flash[:notice] = "Publisher '#{ op.model.name }' updated"
        return redirect_to [:admin, :publishers]
      end
      render_form
    end

    def destroy
      run ::Publisher::Destroy do |op|
        flash[:notice] = "Publisher '#{ op.model.name }' destroyed"
        return redirect_to [:admin, :publishers]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/publisher/cell/form', @form)
    end
  end
end
