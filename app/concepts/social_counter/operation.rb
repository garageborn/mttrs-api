require ::File.expand_path('../callbacks', __FILE__)

class SocialCounter
  class Operation < Trailblazer::Operation
    include Model
    include Callback
    model SocialCounter

    callback :after_save, ::SocialCounter::Callbacks::AfterSave
  end
end
