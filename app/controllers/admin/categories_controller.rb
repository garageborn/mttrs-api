module Admin
  class CategoriesController < ApplicationController
    def index
      present ::Category::Index
      render html: concept('admin/category/cell/index', @model)
    end

    def new
      form ::Category::Create
      render_form
    end

    def edit
      form ::Category::Update
      render_form
    end

    def create
      run ::Category::Create do |op|
        flash[:notice] = "Category '#{ op.model.name }' created"
        return redirect_to [:admin, :categories]
      end
      render_form
    end

    def update
      run ::Category::Update do |op|
        flash[:notice] = "Category '#{ op.model.name }' updated"
        return redirect_to [:admin, :categories]
      end
      render_form
    end

    def destroy
      run ::Category::Destroy do |op|
        flash[:notice] = "Category '#{ op.model.name }' destroyed"
        return redirect_to [:admin, :categories]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/category/cell/form', @form)
    end
  end
end
