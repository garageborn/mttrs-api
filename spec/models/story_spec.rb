require 'rails_helper'

RSpec.describe Story do
  it { should have_db_column(:created_at).with_options(null: false) }
  it { should have_db_column(:total_social).with_options(null: false, default: 0) }
  it { should have_db_column(:updated_at).with_options(null: false) }

  it { should have_many(:links).dependent(:nullify).inverse_of(:story) }
  it { should have_many(:publishers).through(:links) }
  it { should have_many(:categories).through(:links) }
  it { should have_many(:story_namespaces).dependent(:destroy).inverse_of(:story) }
  it { should have_many(:main_links).through(:story_namespaces).source(:main_link) }

  context 'namespaces' do
    let!(:story) { create(:story) }
    let!(:first_story_namespace) { create(:story_namespace, story: story) }
    let!(:second_story_namespace) { create(:story_namespace, story: story) }

    it 'ooooooo' do
      puts "----------"
      p story.reload.main_links.size
      puts "----------"
      Namespaced.current = first_story_namespace.namespace
      p story.reload.main_links.to_sql
      # p Story.limit(100)
      puts "----------"
      Namespaced.current = second_story_namespace.namespace
      p story.reload.main_links.to_sql
      # p Story.limit(100)
      puts "----------"

    end
  end
end
