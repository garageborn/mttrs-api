require 'rails_helper'

RSpec.describe Notification do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:icon_url) }
  it { should have_db_column(:image_url) }
  it { should have_db_column(:message).with_options(null: false) }
  it { should have_db_column(:notificable_id) }
  it { should have_db_column(:notificable_type) }
  it { should have_db_column(:onesignal_id) }
  it { should have_db_column(:title) }
  it { should have_db_column(:segment).with_options(null: false) }
  it { should have_db_column(:updated_at).with_options(null: false) }
  it { should have_db_index(%i[notificable_id notificable_type]) }
  it { should have_db_index(%i[notificable_type notificable_id]) }

  it { should belong_to(:notificable) }
end
