Trailblazer::Cell.class_eval do
  extend Trailblazer::Cell::ViewName::Flat
  include ::Cell::Slim
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include SimpleForm::ActionViewExtensions::FormHelper
end
