require 'rails_helper'

RSpec.describe Namespace do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
end
