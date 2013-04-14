class App < ActiveRecord::Base
  attr_accessible :title, :description, :teaser_description,
    :author, :is_promo, :home_page_url, :develop_app_url, :icon, :screenshot
  mount_uploader :icon, AppIconUploader
  mount_uploader :screenshot, AppScreenshotUploader

  default_scope order('created_at ASC')
end
