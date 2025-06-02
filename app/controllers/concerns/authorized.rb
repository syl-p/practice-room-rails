module Authorized
  extend ActiveSupport::Concern
  included do
    class_attribute :before_authorize_method, instance_writer: false, default: nil
  end

  class_methods do
    def before_authorize(lambda_or_proc)
      self.before_authorize_method = lambda_or_proc
    end
  end

  def authorize!(record, query = nil)
    if self.before_authorize_method
      self.send(self.before_authorize_method)
    end

    policy = get_policy(record)
    query ||= "#{action_name}?"
    unless policy.public_send(query)
      raise NotAuthorizedError, "not allowed to #{query} this #{record.class}"
    end
    true
  end

  def get_policy(record)
    "#{record.class}Policy".constantize.new(Current.session&.user, record)
  rescue NameError
    raise NotAuthorizedError, "No policy defined for #{record.class}"
  end

  class NotAuthorizedError < StandardError; end
end
