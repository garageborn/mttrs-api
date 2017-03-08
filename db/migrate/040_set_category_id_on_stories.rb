class SetCategoryIdOnStories < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def up
    set_category_id
    change_column :stories, :category_id, :integer, null: false
  end

  private

  def set_category_id
    Apartment::Tenant.each do
      Story.find_each { |story| migrate_story(story) }
    end
  end

  def migrate_story(story)
    main_story_link = story.story_links.find_by(main: true) || story.story_links.first
    category_id = main_story_link.link.category.id
    story.update_column(:category_id, category_id)

    story.story_links.each do |story_link|
      next if story_link.link.category.try(:id) == category_id
      StoryBuilderJob.perform_in(10.minutes, story_link.link.id)
      story_link.destroy
    end
    RefreshStoryJob.perform_in(10.minutes, story.id)
  end
end
