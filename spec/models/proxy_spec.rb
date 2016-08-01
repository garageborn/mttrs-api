require 'rails_helper'

RSpec.describe Proxy do
  it { should have_db_column(:active).with_options(null: false, default: true) }
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:ip).with_options(null: false) }
  it { should have_db_column(:port).with_options(null: false) }
  it { should have_db_column(:requested_at) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_db_index([:ip, :port]).unique(true) }
  it { should have_db_index(:active) }
end
