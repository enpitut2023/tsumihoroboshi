class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true
  has_one_attached :image
  has_one :experience
  has_many :tsundokus, dependent: :destroy

  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :likes
  has_many :books, through: :likes
  has_many :timers

  def current_level
    exp / Experience::LEVEL_UP_EXPERIENCE + 1
  end

  def exp_needed_for_current_level
    (current_level - 1) * Experience::LEVEL_UP_EXPERIENCE 
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # お気に入り機能の追加
  def addlike(book)
    likes.find_or_create_by(book_id: book.id)
  end

  def removelike(book)
    like = likes.find_by(book_id: book.id)
    like.destroy if like
  end

  def like?(book)
    books.include?(book)
  end
end
