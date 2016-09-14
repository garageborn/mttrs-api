require 'rails_helper'

RSpec.describe CategoryFeed do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:feed_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:category_id).with_options(null: false) }
  it { should have_db_index([:feed_id, :category_id]).unique(true) }
  it { should have_db_index([:category_id, :feed_id]).unique(true) }

  it { should belong_to(:feed) }
  it { should belong_to(:category) }
end
