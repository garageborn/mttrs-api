require 'rails_helper'

RSpec.describe AmpLink do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_column(:status).with_options(null: false) }
  it { should have_db_column(:url) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:link_id).unique(true) }
  it { should have_db_index(:status) }

  it { should belong_to(:link) }
  it { should define_enum_for(:status).with(%i[pending fetching error success]) }
end
