class Review < ActiveRecord::Base
  attr_accessible :body, :name, :product_id, :rating, :title

  belongs_to :product

  validates :name, presence: true
  validates :product_id, presence: true
  validates :rating, presence: true
  validates :title, presence: true
  validates :body, presence: true
  
  # The 30 most recent reviews
  scope :most_recent, order("created_at desc").limit(30)

end