module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_source_field, instance_writer: false, default: :title

    before_validation :generate_slug, if: -> { slug.blank? }
    validates :slug, uniqueness: true, presence: true, unless: :slug_source_blank?
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
  # Le slug est dérivé de sa source. Si la source manque, c'est elle qui est
  # en erreur : on évite le message "Slug doit être rempli(e)".
  def slug_source_blank?
    field = self.class.slug_source_field

    field.present? && self[field].blank?
  end

  def generate_slug
    base = self.class.slug_source_field ? self.send(self.class.slug_source_field) : nil
    return if base.blank?

    candidate = base.to_s.parameterize.presence || SecureRandom.uuid
    slug_candidate = candidate
    index = 1

    while self.class.where(slug: slug_candidate).where.not(id: id).exists?
      slug_candidate = "#{candidate}-#{index}"
      index += 1
    end

    self.slug = slug_candidate
  end
end
