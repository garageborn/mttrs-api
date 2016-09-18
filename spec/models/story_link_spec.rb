require 'rails_helper'

RSpec.describe StoryLink do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_column(:main).with_options(null: false, default: 0) }
  it { should have_db_column(:story_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:link_id, :story_id]).unique(true) }
  it { should have_db_index([:main, :story_id]) }
  it { should have_db_index([:story_id, :link_id]).unique(true) }

  it { should belong_to(:story) }
  it { should belong_to(:link) }
end
