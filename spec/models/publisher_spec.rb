require 'rails_helper'

RSpec.describe Publisher do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:icon_id) }
  it { should have_db_column(:language).with_options(default: 'en', null: false) }
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:slug).unique(true) }

  it { should have_many(:blocked_urls).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:category_matchers).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:feeds).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:links).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:publisher_domains).inverse_of(:publisher).dependent(:destroy) }
  it { should have_many(:title_replacements).inverse_of(:publisher).dependent(:destroy) }

  # describe 'Validations' do
  #   subject { build(:publisher) }
  #   it { is_expected.to validate_presence_of(:name) }
  #   it { is_expected.to validate_presence_of(:domain) }
  #   it { is_expected.to validate_presence_of(:slug) }
  #   it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  #   it { is_expected.to validate_uniqueness_of(:domain).case_insensitive }
  #   it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
  # end
end
