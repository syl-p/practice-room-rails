module CommentsHelper
  MENTION_BODY = /\w+(?:[.-]\w+)*/
  MENTION_PATTERN = /@(#{MENTION_BODY})/

  def render_comment_content(comment)
    content = comment.content.to_s
    usernames = content.scan(MENTION_PATTERN).flatten.uniq
    users = User.where(username: usernames).index_by(&:username)

    safe_join(
      content.split(/(@#{MENTION_BODY})/).map do |part|
        username = part.delete_prefix("@")

        if part.start_with?("@") && (user = users[username])
          link_to(part, user, data: { turbo: false })
        else
          part
        end
      end
    )
  end
end
