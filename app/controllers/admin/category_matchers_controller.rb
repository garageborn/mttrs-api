module Admin
  class CategoryMatchersController < BaseController
    def index
      present ::CategoryMatcher::Index
      render html: concept('admin/category_matcher/cell/index', @model)
    end

    def new
      form ::CategoryMatcher::Create
      render_form
    end

    def edit
      form ::CategoryMatcher::Update
      render_form
    end

    def create
      run ::CategoryMatcher::Create do |op|
        return render_form if op.contract.try_out
        flash[:notice] = "Category Matcher '#{ op.model.id }' created"
        return redirect_to [:admin, :category_matchers]
      end
      render_form
    end

    def update
      run ::CategoryMatcher::Update do |op|
        return render_form if op.contract.try_out
        flash[:notice] = "Category Matcher '#{ op.model.id }' updated"
        return redirect_to [:admin, :category_matchers]
      end
      render_form
    end

    def destroy
      run ::CategoryMatcher::Destroy do |op|
        flash[:notice] = "Category Matcher '#{ op.model.id }' destroyed"
        return redirect_to [:admin, :category_matchers]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/category_matcher/cell/form', @form)
    end
  end
end
