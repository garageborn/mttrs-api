require 'rails_helper'

RSpec.describe Publisher do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:domain).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:slug).unique(true) }

  it { should have_many(:feeds).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:categories).through(:feeds) }
  it { should have_many(:category_matchers).inverse_of(:publisher).dependent(:destroy) }

  describe 'Validations' do
    subject { build(:publisher) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:domain) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
