class Article < ApplicationRecord
 mount_uploader :image, ImageUploader
 validates_processing_of :image
 validate :image_size_validation
 before_create :set_slug

 def to_param
    "#{id}-#{slug}"
  end

 private
  def image_size_validation
    errors[:image] << "should be less than 500KB" if image.size > 0.5.megabytes
  end

  def set_slug
    self.slug = title.parameterize
  end
end
