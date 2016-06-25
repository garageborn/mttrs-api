require 'rails_helper'

RSpec.describe Story do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_many(:links).dependent(:nullify).inverse_of(:story) }
end
