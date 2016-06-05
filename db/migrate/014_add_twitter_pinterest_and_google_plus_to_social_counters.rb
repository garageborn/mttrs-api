class AddTwitterPinterestAndGooglePlusToSocialCounters < ActiveRecord::Migration
  def change
    add_column :social_counters, :twitter, :integer, null: false, default: 0
    add_column :social_counters, :pinterest, :integer, null: false, default: 0
    add_column :social_counters, :google_plus, :integer, null: false, default: 0
  end
end
