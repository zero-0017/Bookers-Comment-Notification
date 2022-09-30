class Book < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_many :notifications, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

def create_notification_book!(current_user)
  # 全ユーザーを取得
  temp_ids = User.all.select(:id).distinct
  temp_ids.each do |temp_id|
    save_notification_book!(current_user, temp_id['id'])
  end
end

def save_notification_book!(current_user, visited_id)
  book = current_user.active_notifications.new(
      visited_id: visited_id,
      book_id: id,
      action: 'book'
    )
    book.save if book.valid?
end

def create_notification_comment!(current_user, comment_id)
	    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
	    temp_ids = Comment.select(:user_id).where(book_id: id).where.not(user_id: current_user.id).distinct
	    temp_ids.each do |temp_id|
	        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
        end
    	# まだ誰もコメントしていない場合は、投稿者に通知を送る
    	save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
end

  	def save_notification_comment!(current_user, comment_id, visited_id)
        # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
        notification = current_user.active_notifications.new(
          book_id: id,
          comment_id: comment_id,
          visited_id: visited_id,
          action: 'comment'
        )
        # 自分の投稿に対するコメントの場合は、通知済みとする
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
     end

end
