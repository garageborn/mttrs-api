require 'rails_helper'

RSpec.describe SocialCounter do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:facebook).with_options(null: false, default: 0) }
  it { should have_db_column(:linkedin).with_options(null: false, default: 0) }
  it { should have_db_column(:story_id).with_options(null: false) }
  it { should have_db_column(:total).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:story_id, :total]) }

  it { should belong_to(:story) }

  describe 'Validations' do
    subject { build(:social_counter) }
    it { is_expected.to validate_presence_of(:story) }
    it { is_expected.to validate_presence_of(:facebook) }
    it { is_expected.to validate_presence_of(:linkedin) }
    it { is_expected.to validate_presence_of(:total) }
    it { is_expected.to validate_numericality_of(:facebook).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:linkedin).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:total).only_integer.is_greater_than_or_equal_to(0) }
  end

  it { is_expected.to callback(:update_total).before(:save) }
  it { is_expected.to callback(:update_total_social_on_story).after(:commit) }
end
