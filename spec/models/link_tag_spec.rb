require 'rails_helper'

RSpec.describe LinkTag do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_column(:tag_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:link_id, :tag_id]).unique(true) }
  it { should have_db_index([:tag_id, :link_id]).unique(true) }

  it { should belong_to(:link) }
  it { should belong_to(:tag) }
end
