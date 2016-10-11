require 'rails_helper'

RSpec.describe Feed do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:language).with_options(default: 'en', null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:url).with_options(null: false) }
  it { should have_db_index(:publisher_id) }
  it { should have_db_index(:url).unique(true) }

  it { should belong_to(:publisher) }
  it { should have_many(:category_feeds).inverse_of(:feed).dependent(:destroy) }
  it { should have_many(:categories).through(:category_feeds) }
  it { should have_many(:feed_links).dependent(:destroy).inverse_of(:feed) }
  it { should have_many(:links).through(:feed_links) }

  # describe 'Validations' do
  #   subject { build(:feed) }
  #   it { is_expected.to validate_presence_of(:publisher) }
  #   it { is_expected.to validate_presence_of(:url) }
  #   it { is_expected.to validate_inclusion_of(:language).in_array(Utils::Language::AVAILABLE_LANGUAGES).allow_blank }
  #   it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
  # end
end
