class Task < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true
  validates :plan_date, presence: true
end
