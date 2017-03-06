require 'rails_helper'

RSpec.describe PublisherSuggestion do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:count).with_options(null: false, default: 0) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:count) }
end
