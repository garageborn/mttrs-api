require 'rails_helper'

RSpec.describe BlockedStoryLink do
  it { should have_db_column(:story_id).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(%i[story_id link_id]).unique(true) }
  it { should have_db_index(%i[story_id link_id]).unique(true) }

  it { should belong_to(:link) }
  it { should belong_to(:story) }
end
