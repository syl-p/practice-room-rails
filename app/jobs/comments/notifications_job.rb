class Comments::NotificationsJob < ApplicationJob
  queue_as :default

  def perform(comment_id, mentioned_user_ids = nil)
    comment = Comment.find(comment_id)

    # Do something later
    if comment.commentable.respond_to?(:user) && comment.commentable.user != comment.user
      Notification.create!(
        user: comment.commentable.user,
        notifiable: comment,
        notification_type: :comment
      )
    end

    if mentioned_user_ids.present?
      User.where(id: mentioned_user_ids).find_each do |user|
        Notification.create!(user: user, notifiable: comment, notification_type: :mention)
      end
    end
  end
end
