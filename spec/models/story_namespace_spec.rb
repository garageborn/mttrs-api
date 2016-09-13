require 'rails_helper'

RSpec.describe StoryNamespace do
  it { should have_db_column(:story_id).with_options(null: false) }
  it { should have_db_column(:namespace_id).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:main_link_id).with_options(null: false) }

  it { should belong_to(:story) }
  it { should belong_to(:namespace) }
end
