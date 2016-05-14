require 'rails_helper'

RSpec.describe Story do
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:url).with_options(null: false) }
  it { should have_db_column(:status).with_options(null: false, default: 0) }
  it { should have_db_column(:title) }
  it { should have_db_column(:description) }
  it { should have_db_column(:content) }
  it { should have_db_column(:image_public_id) }
  it { should have_db_column(:social).with_options(default: '{}') }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(:status) }
  it { should have_db_index(:publisher_id) }
  it { should have_db_index(:status) }
  it { should have_db_index(:url).unique(true) }

  it { should belong_to(:publisher) }
  it { should have_and_belong_to_many(:feeds) }
  it { should have_many(:categories).through(:feeds) }

  it { define_enum_for(:status).with(%i(pending fetching ready error)) }

  describe 'Validations' do
    subject { build(:story) }
    it { is_expected.to validate_presence_of(:publisher) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
  end
end
