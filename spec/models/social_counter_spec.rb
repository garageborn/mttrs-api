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

  it { is_expected.to callback(:update_total).before(:save) }
end
