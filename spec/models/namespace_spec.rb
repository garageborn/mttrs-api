require 'rails_helper'

RSpec.describe Namespace do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:slug).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_and_belong_to_many(:categories) }
  it { should have_and_belong_to_many(:feeds) }
  it { should have_and_belong_to_many(:links) }
  it { should have_many(:stories).through(:links) }
end
