module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_source_field, instance_writer: false, default: :title

    before_validation :generate_slug, if: -> { slug.blank? }
    validates :slug, uniqueness: true, presence: true
  end

  class_methods do
    def slug_from(field)
      self.slug_source_field = field
    end

    def find_by_slug(slug)
      find_by(slug: slug)
    end
  end

  private
  def generate_slug
    base = self.class.slug_source_field ? self.send(self.class.slug_source_field) : self.to_s
    self.slug = base.parameterize || SecureRandom.uuid


    results = self.class.where(slug: slug).where.not(id: id)
    if results.exists?
      increment = 1
      results.each do |result|
        if result.slug == slug
          increment += 1
        end
      end

      self.slug = "#{slug}-#{increment}"
    end
  end
end
