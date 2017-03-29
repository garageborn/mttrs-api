require 'rails_helper'

RSpec.describe TagMatcher do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:html_matcher) }
  it { should have_db_column(:html_matcher_selector) }
  it { should have_db_column(:tag_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:url_matcher) }
  it { should have_db_index(:tag_id) }

  it { should belong_to(:tag) }
end
