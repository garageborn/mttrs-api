require 'rails_helper'

RSpec.describe Access do
  it { should have_db_column(:accessable_type).with_options(null: false) }
  it { should have_db_column(:accessable_id).with_options(null: false) }
  it { should have_db_column(:date).with_options(null: false) }
  it { should have_db_index(%i[accessable_type accessable_id date]).unique(true) }
  it { should have_db_index(:date) }
  it { should have_db_index(:hits) }

  it { should belong_to(:accessable) }
end
