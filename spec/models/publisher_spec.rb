require 'rails_helper'

RSpec.describe Publisher do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:icon_id) }
  it { should have_db_column(:language).with_options(default: 'en', null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:display_name) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:restrict_content).with_options(null: false, default: false) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:slug).unique(true) }

  it { should have_many(:attribute_matchers).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:blocked_urls).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:category_matchers).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:links).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:publisher_domains).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:tag_matchers).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:title_replacements).inverse_of(:publisher).dependent(:destroy) }
end
