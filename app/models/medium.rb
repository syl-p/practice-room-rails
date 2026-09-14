class Medium < ApplicationRecord
  has_one_attached :file
  belongs_to :user

  scope :matching_filename, lambda { |pattern|
    joins(:file_blob)
      .where("LOWER(active_storage_blobs.filename) LIKE ?", "%#{pattern.downcase}%")
  }

  validates_presence_of :file

  validate :check_file_extension
  validate :check_file_size

  def check_file_extension
    return unless file.attached?

    unless file.content_type.in?(%w[image/jpeg image/jpg image/png image/gif video/mp4 audio/mpeg audio/wav application/pdf])
      errors.add :file, "Must be a valid file extension"
    end
  end

  def check_file_size
    return unless file.attached?

    if file.blob.byte_size > 3.megabytes
      errors.add :file, "Must be a valid file size"
    end
  end
end
