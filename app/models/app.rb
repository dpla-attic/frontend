class App < ActiveRecord::Base
  attr_accessible :author, :description, :home_page_url, :title, :icon, :screenshot
  mount_uploader :icon, AppIconUploader
  mount_uploader :screenshot, AppScreenshotUploader
end
