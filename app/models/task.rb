class Task < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true
  validates :plan_date, presence: true
end
