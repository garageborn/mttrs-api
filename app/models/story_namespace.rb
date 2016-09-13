class StoryNamespace < ApplicationRecord
  include Concerns::Filterable

  belongs_to :story
  belongs_to :main_link, foreign_key: :main_link_id, class_name: 'Link'
  belongs_to :namespace
  has_many :links, through: :story

  delegate :uri, :url, :title, :image_source_url, :published_at, to: :main_link

  # def refresh!(_link = nil)
  #   return destroy if links.blank?
  #   refresh_total_social
  #   refresh_main_link
  # end

  # private

  # def refresh_total_social
  #   update_attributes(total_social: links.sum(:total_social).to_i)
  # end

  # def refresh_main_link
  #   main_link = links.popular.first
  #   main_link.update_column(:main, true)
  #   links.where.not(id: main_link).update_all(main: false)
  # end
end
