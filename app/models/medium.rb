class Medium < ApplicationRecord
  has_one_attached :file
  belongs_to :user

  validates_presence_of :file
  validate :check_file_extension

  def check_file_extension
    return unless file.attached?

    unless file.content_type.in?(%w[image/jpeg image/jpg image/png image/gif video/mp4 audio/mpeg audio/wav application/pdf])
      errors.add :file, "Must be a valid file extension"
    end
  end
end
