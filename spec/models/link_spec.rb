require 'rails_helper'

RSpec.describe Link do
  it { should have_db_column(:content) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:description) }
  it { should have_db_column(:html) }
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
  it { should have_many(:categories).through(:category_links) }
  it { should have_many(:category_links).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:link_urls).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:feed_links).inverse_of(:link).dependent(:destroy) }
  it { should have_many(:feeds).through(:feed_links) }
  it { should have_many(:social_counters).inverse_of(:link).dependent(:destroy) }
  it { should have_one(:social_counter).order(id: :desc) }

  # describe 'Validations' do
  #   subject { build(:link) }
  #   it { is_expected.to validate_presence_of(:title) }
  #   it { is_expected.to_not validate_presence_of(:description) }
  #   it { is_expected.to validate_presence_of(:published_at) }
  #   it { is_expected.to validate_inclusion_of(:language).in_array(Utils::Language::EXISTING_LANGUAGES).allow_blank }
  # end
end
