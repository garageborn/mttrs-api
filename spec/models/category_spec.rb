require 'rails_helper'

RSpec.describe Category do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:color) }
  it { should have_db_column(:icon_id) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:slug).unique(true) }

  it { should have_many(:category_feeds).inverse_of(:category).dependent(:destroy) }
  it { should have_many(:category_links).inverse_of(:category).dependent(:destroy) }
  it { should have_many(:category_matchers).inverse_of(:category).dependent(:destroy) }
  it { should have_many(:feeds).through(:category_feeds) }
  it { should have_many(:links).through(:category_links) }

  # describe 'Validations' do
  #   subject { build(:category) }
  #   it { is_expected.to validate_presence_of(:name) }
  #   it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  # end
end
