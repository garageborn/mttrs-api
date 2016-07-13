class AddMainToLinks < ActiveRecord::Migration
  class Story < ActiveRecord::Base
    has_many :links
  end

  class Link < ActiveRecord::Base
    belongs_to :story
    scope :popular, -> { order(total_social: :desc) }
  end

  def change
    add_column :links, :main, :boolean, defaut: 0, null: false
    Story.all
  end

  private

  def set_main_links
    Story.find_each do |story|
      main_link = story.links.popular.first
      main_link.update_column(main: true)
      story.links.where.not(id: main_link).update_all(:main, false)
    end
  end
end
