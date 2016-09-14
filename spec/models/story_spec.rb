require 'rails_helper'

RSpec.describe Story do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_many(:categories).through(:links) }
  it { should have_many(:story_links).inverse_of(:story).dependent(:destroy) }
  it { should have_many(:links).through(:story_links) }
  it { should have_many(:publishers).through(:links) }
  # it { should have_one(:main_link).class_name('Link') }
end
