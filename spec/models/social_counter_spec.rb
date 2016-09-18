require 'rails_helper'

RSpec.describe SocialCounter do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:facebook).with_options(null: false, default: 0) }
  it { should have_db_column(:linkedin).with_options(null: false, default: 0) }
  it { should have_db_column(:twitter).with_options(null: false, default: 0) }
  it { should have_db_column(:pinterest).with_options(null: false, default: 0) }
  it { should have_db_column(:google_plus).with_options(null: false, default: 0) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_column(:parent_id) }
  it { should have_db_column(:total).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:link_id, :total]) }
  it { should have_db_index(:parent_id).unique(true) }

  it { should belong_to(:link) }
  it { should have_one(:parent).class_name('SocialCounter').with_foreign_key(:parent_id) }

  # describe 'Validations' do
  #   subject { build(:social_counter) }
  #   it { is_expected.to validate_presence_of(:link) }
  #   it { is_expected.to validate_presence_of(:facebook) }
  #   it { is_expected.to validate_presence_of(:linkedin) }
  #   it { is_expected.to validate_presence_of(:twitter) }
  #   it { is_expected.to validate_presence_of(:pinterest) }
  #   it { is_expected.to validate_presence_of(:google_plus) }
  #   it { is_expected.to validate_presence_of(:total) }
  #   it { is_expected.to validate_uniqueness_of(:parent_id).allow_blank }
  #   it { is_expected.to validate_numericality_of(:facebook).only_integer.is_greater_than_or_equal_to(0) }
  #   it { is_expected.to validate_numericality_of(:linkedin).only_integer.is_greater_than_or_equal_to(0) }
  #   it { is_expected.to validate_numericality_of(:twitter).only_integer.is_greater_than_or_equal_to(0) }
  #   it { is_expected.to validate_numericality_of(:pinterest).only_integer.is_greater_than_or_equal_to(0) }
  #   it { is_expected.to validate_numericality_of(:google_plus).only_integer.is_greater_than_or_equal_to(0) }
  #   it { is_expected.to validate_numericality_of(:total).only_integer.is_greater_than_or_equal_to(0) }
  # end

  it { is_expected.to callback(:update_total).before(:save) }
end
