require 'rails_helper'

RSpec.describe LinkUrl do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:url).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_column(:link_id).with_options(null: false) }
  it { should have_db_index(:url).unique(true) }
  it { should have_db_index(%i[link_id url]).unique(true) }

  it { should belong_to(:link) }

  # describe 'Validations' do
  #   subject { build(:link_url) }
  #   it { is_expected.to validate_presence_of(:link) }
  #   it { is_expected.to validate_presence_of(:url) }
  #   it { is_expected.to validate_uniqueness_of(:url).case_insensitive }

  #   describe '#validate_unique_link' do
  #     let!(:first_link) { create(:link) }
  #     subject do
  #       build(
  #         :link,
  #         publisher: first_link.publisher,
  #         title: first_link.title,
  #         url: "#{ first_link.url }?param=foo"
  #       )
  #     end
  #     its(:valid?) { is_expected.to be_falsey }
  #   end
  # end
end
