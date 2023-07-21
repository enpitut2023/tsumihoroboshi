class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :name, presence: true
  has_one_attached :image
  has_one :experience
  has_many :tsundokus, dependent: :destroy

  def current_level
    exp / Experience::LEVEL_UP_EXPERIENCE
  end

  def exp_needed_for_current_level
    current_level * Experience::LEVEL_UP_EXPERIENCE
  end
end
