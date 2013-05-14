class Post < ActiveRecord::Base
  attr_accessible :body, :private, :title
  validates :body, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 3, maximum: 30 }
  validates_presence_of :private
end
