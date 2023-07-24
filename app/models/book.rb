class Book < ApplicationRecord
    validates :title, presence: true
    has_one_attached :image
    has_many :tsundokus, dependent: :destroy
    has_many :likes, foreign_key: 'book_id', dependent: :destroy
    has_many :users, through: :likes
end
