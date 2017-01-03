require 'rails_helper'

RSpec.describe CategoryMatcher do
  it { should have_db_column(:category_id).with_options(null: false) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:publisher_id).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:url_matcher) }
  it { should have_db_column(:html_matcher) }
  it { should have_db_column(:html_matcher_selector) }
  it { should have_db_index([:category_id, :publisher_id]) }
  it { should have_db_index([:publisher_id, :category_id]) }

  it { should belong_to(:publisher) }
  it { should belong_to(:category) }

  describe 'Validations' do
    subject { build(:category_matcher) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:publisher) }
    xit { is_expected.to validate_uniqueness_of(:url_matcher).scoped_to(:publisher_id).allow_blank }
  end
end
