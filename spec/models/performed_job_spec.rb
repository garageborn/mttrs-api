require 'rails_helper'

RSpec.describe PerformedJob do
  it { should have_db_column(:type).with_options(null: false) }
  it { should have_db_column(:key).with_options(null: false) }
  it { should have_db_column(:status).with_options(null: false) }
  it { should have_db_column(:performs).with_options(null: false, default: 0) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index([:type, :key]).unique(true) }

  it { should define_enum_for(:status).with(%i(pending enqueued running error success)) }

  describe 'Validations' do
    subject { build(:performed_job) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:performs) }
    it { is_expected.to validate_uniqueness_of(:type).scoped_to(:key).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:type).case_insensitive }
  end
end
