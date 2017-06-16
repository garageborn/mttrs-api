require 'rails_helper'

RSpec.describe Link do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:description) }
  it { should have_db_column(:image_source_url) }
  it { should have_db_column(:language) }
  it { should have_db_column(:published_at).with_options(null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:title).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:published_at) }
  it { should have_db_index(:publisher_id) }
  it { should have_db_index(:total_social) }

  it { should belong_to(:publisher) }
  it { should have_many(:blocked_story_links).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:link_tags).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:link_urls).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:social_counters).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:tags).through(:link_tags) }
  it { should have_one(:amp_link).inverse_of(:link).dependent(:destroy) }
  it { should have_one(:category).through(:category_link) }
  it { should have_one(:category_link).inverse_of(:link).dependent(:destroy) }
  it { should have_one(:social_counter).order(id: :desc) }
  it { should have_one(:story).through(:story_link) }
  it { should have_one(:story_link).inverse_of(:link).dependent(:destroy) }
end
