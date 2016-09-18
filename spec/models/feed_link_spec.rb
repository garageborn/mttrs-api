require 'rails_helper'

RSpec.describe FeedLink do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:feed_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_index([:feed_id, :link_id]).unique(true) }
  it { should have_db_index([:link_id, :feed_id]).unique(true) }

  it { should belong_to(:feed) }
  it { should belong_to(:link) }
end
