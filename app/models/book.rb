class Book < ApplicationRecord
    validates :title, presence: true
    has_one_attached :image
    has_many :tsundokus, dependent: :destroy
end
