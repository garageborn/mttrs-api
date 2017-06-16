module Admin
  class PublisherSuggestionsController < BaseController
    def index
      present ::PublisherSuggestion::Index
      render html: concept('admin/publisher_suggestion/cell/index', @model)
    end

    def new
      form ::PublisherSuggestion::Create
      render_form
    end

    def edit
      form ::PublisherSuggestion::Update
      render_form
    end

    def create
      run ::PublisherSuggestion::Create do |op|
        flash[:notice] = "Publisher suggestion '#{ op.model.name }' created"
        return redirect_to %i[admin publisher_suggestions]
      end
      render_form
    end

    def update
      run ::PublisherSuggestion::Update do |op|
        flash[:notice] = "Publisher suggestion '#{ op.model.name }' updated"
        return redirect_to %i[admin publisher_suggestions]
      end
      render_form
    end

    def destroy
      run ::PublisherSuggestion::Destroy do |op|
        flash[:notice] = "Publisher suggestion '#{ op.model.name }' destroyed"
        return redirect_to %i[admin publisher_suggestions]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/publisher_suggestion/cell/form', @form)
    end
  end
end
