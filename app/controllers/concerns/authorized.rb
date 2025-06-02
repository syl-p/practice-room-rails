module Authorized
  extend ActiveSupport::Concern

  def authorize!(record, query = nil)
    resume_session
    
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
