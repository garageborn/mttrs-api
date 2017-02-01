require 'reform'
require 'reform/form/active_model'
require 'reform/form/active_model/model_reflections'
require 'reform/form/active_model/model_validations'
require 'reform/form/active_model/validations'
require 'reform/form/coercion'
require 'reform/form/validation/unique_validator'

require 'cloudinary/helper'

Trailblazer::Cell.class_eval do
  extend Trailblazer::Cell::ViewName::Flat
  include ::Cell::Slim
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper
  include Kaminari::Cells
  include Cocoon::ViewHelpers
  include CloudinaryHelper
end

Reform::Form.class_eval do
  include Reform::Form::ModelReflections
end
