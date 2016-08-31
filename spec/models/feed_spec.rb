require 'rails_helper'

RSpec.describe Feed do
  it { should have_db_column(:category_id).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:language).with_options(default: 'en', null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:publisher_id, :category_id]) }
  it { should have_db_index([:category_id, :publisher_id]) }
  it { should have_db_index(:url).unique(true) }

  it { should belong_to(:publisher) }
  it { should belong_to(:category) }
  it { should have_and_belong_to_many(:links) }
  it { should have_and_belong_to_many(:namespaces) }

  describe 'Validations' do
    subject { build(:feed) }
    it { is_expected.to validate_presence_of(:publisher) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
  end
end
