class TitleReplacementsJob
  include Sidekiq::Worker

  def perform(publisher_id)
    Publisher::ApplyTitleReplacements.run(id: publisher_id)
  end
end
