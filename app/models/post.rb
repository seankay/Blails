class Post < ActiveRecord::Base
  attr_accessible :body, :private, :title
  validates :body, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 3, maximum: 30 }
  validates_presence_of :private

  def increment_view_count!
    self.view_count += 1
    self.save!
  end

  def increment_edit_count!
    self.edit_count += 1
    self.save!
  end
end
