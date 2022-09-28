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
end
