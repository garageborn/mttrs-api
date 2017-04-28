RSpec.configure do |config|
  config.before(:suite) do
    Link.__elasticsearch__.create_index!
  end
end
