require 'rails_helper'

RSpec.describe Tag do
  it { should have_db_column(:category_id).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:order).with_options(null: false, default: 0) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:category_id, :order]) }
  it { should have_db_index(:slug).unique(true) }

  it { should belong_to(:category) }
  it { should have_many(:tag_matchers).inverse_of(:tag).dependent(:destroy) }
  it { should have_many(:link_tags).inverse_of(:tag).dependent(:destroy) }
  it { should have_many(:links).through(:link_tags) }
end
