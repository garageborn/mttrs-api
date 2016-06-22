require 'rails_helper'

RSpec.describe Cluster do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_many(:stories).dependent(:destroy).inverse_of(:cluster) }
end
