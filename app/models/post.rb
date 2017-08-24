class Post < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 200 }
end