class Book < ApplicationRecord
  has_one_attached :image

  belongs_to :author
  belongs_to :publisher
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :borrow_request_items, dependent: :destroy
  has_many :borrow_requests, through: :borrow_request_items
  has_many :reviews, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :publication_year,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :total_quantity,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :available_quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: :total_quantity
            }

  validates :borrow_count,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :author_id, presence: true
  validates :publisher_id, presence: true

  scope :search, ->(q) {
    where("id = ? OR title LIKE ?", q.to_i, "%#{q}%") if q.present?
  }

  scope :recent, -> { order(created_at: :desc) }
end
