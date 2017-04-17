module Admin
  class NotificationsController < BaseController
    def index
      present ::Notification::Index
      render html: concept('admin/notification/cell/index', @model)
    end

    def new
      form ::Notification::Create
      render_form
    end

    def edit
      form ::Notification::Update
      render_form
    end

    def create
      run ::Notification::Create do |op|
        flash[:notice] = "Notification '#{ op.model.title }' created"
        return redirect_to [:admin, :notifications]
      end
      render_form
    end

    def update
      run ::Notification::Update do |op|
        flash[:notice] = "Notification '#{ op.model.title }' updated"
        return redirect_to [:admin, :notifications]
      end
      render_form
    end

    def destroy
      run ::Notification::Destroy do |op|
        flash[:notice] = "Notification '#{ op.model.title }' destroyed"
        return redirect_to [:admin, :notifications]
      end
      render_form
    end

    private

    def render_form
      render html: concept('admin/notification/cell/form', @form)
    end
  end
end
