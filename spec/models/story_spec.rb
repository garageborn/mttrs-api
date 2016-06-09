require 'rails_helper'

RSpec.describe Story do
  it { should have_db_column(:content) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:description) }
  it { should have_db_column(:html) }
  it { should have_db_column(:image_source_url) }
  it { should have_db_column(:published_at).with_options(null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:source_url).with_options(null: false) }
  it { should have_db_column(:title).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:url).with_options(null: false) }
  it { should have_db_index(:publisher_id) }
  it { should have_db_index(:source_url).unique(true) }
  it { should have_db_index(:total_social) }
  it { should have_db_index(:url).unique(true) }

  it { should belong_to(:publisher) }
  it { should have_one(:social_counter).order(id: :desc) }
  it { should have_and_belong_to_many(:feeds) }
  it { should have_many(:social_counters).dependent(:destroy).inverse_of(:story) }
  it { should have_and_belong_to_many(:categories) }

  describe 'Validations' do
    subject { build(:story) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to_not validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:publisher) }
    it { is_expected.to validate_presence_of(:source_url) }
    it { is_expected.to validate_uniqueness_of(:source_url).case_insensitive }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).case_insensitive }
    it { is_expected.to validate_presence_of(:published_at) }

    describe '#validate_unique_story' do
      let!(:first_story) { create(:story) }
      subject do
        build(
          :story,
          publisher: first_story.publisher,
          title: first_story.title,
          url: "#{ first_story.url }?param=foo"
        )
      end
      its(:valid?) { is_expected.to be_falsey }
    end
  end
end
