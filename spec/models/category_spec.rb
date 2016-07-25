require 'rails_helper'

RSpec.describe Category do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:name).unique(true) }
  it { should have_db_index(:slug).unique(true) }

  it { should have_and_belong_to_many(:links) }
  it { should have_many(:category_matchers).inverse_of(:category).dependent(:destroy) }
  it { should have_many(:feeds).inverse_of(:category).dependent(:destroy) }
  it { should have_many(:publishers).through(:links) }

  describe 'Validations' do
    subject { build(:category) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
