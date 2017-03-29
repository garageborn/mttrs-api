module Admin
  class TagMatchersController < BaseController
    def index
      present ::TagMatcher::Index
      render html: concept('admin/tag_matcher/cell/index', @model)
    end

    def new
      form ::TagMatcher::Create
      render_form
    end

    def edit
      form ::TagMatcher::Update
      render_form
    end

    def create
      run ::TagMatcher::Create do |op|
        return render_form if op.contract.try_out
        flash[:notice] = "Tag Matcher '#{ op.model.id }' created"
        return redirect_to %i(admin tag_matchers)
      end
      render_form
    end

    def update
      run ::TagMatcher::Update do |op|
        return render_form if op.contract.try_out
        flash[:notice] = "Tag Matcher '#{ op.model.id }' updated"
        return redirect_to %i(admin tag_matchers)
      end
      render_form
    end

    def destroy
      run ::TagMatcher::Destroy do |op|
        flash[:notice] = "Tag Matcher '#{ op.model.id }' destroyed"
        return redirect_to %i(admin tag_matchers)
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/tag_matcher/cell/form', @form)
    end
  end
end
