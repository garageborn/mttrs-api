require 'rails_helper'

RSpec.describe CategoryLink do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:category_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_index(%i[category_id link_id]).unique(true) }
  it { should have_db_index(%i[link_id category_id]).unique(true) }

  it { should belong_to(:category) }
  it { should belong_to(:link) }
end
