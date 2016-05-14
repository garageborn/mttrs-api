require 'rails_helper'

RSpec.describe Category do
  it { should have_db_column(:name).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:name).unique(true) }

  it { should have_many(:feeds) }
  it { should have_many(:publishers).through(:feeds) }
  it { should have_many(:stories).through(:feeds) }

  describe 'Validations' do
    subject { build(:category) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
