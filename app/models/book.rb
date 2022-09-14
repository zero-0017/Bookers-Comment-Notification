class Book < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
end
