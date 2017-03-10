class TitleReplacementsJob
  include Sidekiq::Worker

  sidekiq_options queue: :title_replacements

  def perform(publisher_id)
    Publisher::ApplyTitleReplacements.run(id: publisher_id)
  end
end
