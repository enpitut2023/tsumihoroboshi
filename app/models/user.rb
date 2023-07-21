class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true
  has_one_attached :image
  has_many :tsundokus, dependent: :destroy
end
