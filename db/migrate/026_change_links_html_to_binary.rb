class ChangeLinksHtmlToBinary < ActiveRecord::Migration
  class Link < ApplicationRecord; end

  def change
    add_column :links, :html_data, :binary
    convert_html_to_binary
    remove_column :links, :html
    rename_column :links, :html_data, :html
  end

  private

  def convert_html_to_binary
    Link.find_each.with_index do |link, index|
      next unless link.html.present?
      result = link.update_column(:html_data, Zlib::Deflate.deflate(link.html.to_s))
      Rails.logger.info "ChangeLinksHtmlToBinary: #{ result } #{ index + 1 }/#{ Link.count }"
    end
  end
end
