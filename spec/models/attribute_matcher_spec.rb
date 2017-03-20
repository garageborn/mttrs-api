require 'rails_helper'

RSpec.describe AttributeMatcher do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:matcher).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:publisher_id, :name]) }

  it { should belong_to(:publisher) }
end
