ActiveSupport::Notifications.subscribe('link.committed') do |_name, _start, _finish, _id, link|
  story_ids = (
    link.previous_changes[:story_id].to_a +
    link.changes[:story_id].to_a +
    [link.story_id]
  ).compact.uniq
  next if story_ids.blank?
  stories = Story.where(id: story_ids)
  next if stories.blank?

  stories.each(&:refresh!)
end
