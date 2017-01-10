require 'rails_helper'

RSpec.describe Access do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:accessable_type).with_options(null: false) }
  it { should have_db_column(:accessable_id).with_options(null: false) }
  it { should have_db_index([:accessable_type, :accessable_id]).unique(true) }
  it { should have_db_index(:hits) }
  it { should have_db_index(:created_at) }

  it { should belong_to(:accessable) }
end
