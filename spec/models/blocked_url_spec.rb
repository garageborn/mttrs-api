require 'rails_helper'

RSpec.describe BlockedUrl do
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:matcher).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:publisher_id) }

  it { should belong_to(:publisher) }
end
