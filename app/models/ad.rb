class Ad < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :name, presence: true, length: { maximum: 50 }
end
