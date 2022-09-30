module NotificationsHelper
  def notification_form(notification)
	  @visitor = notification.visitor
	  @comment = nil
	  your_book = link_to 'あなたの投稿', users_path(notification), style:"font-weight: bold;"
	  @visiter_comment = notification.comment_id
	  case notification.action
	 when "comment" then
	  @comment = Comment.find_by(id: @visitor_comment)&.content
	   tag.a(@visitor.name, href:users_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:users_path(notification.book_id), style:"font-weight: bold;")+"にコメントしました"
	 end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
