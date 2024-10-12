class User < ApplicationRecord
  #validates :name, :email, :password, presence: true
  validates :name, :email, presence: true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,:validatable

  has_many :posts, dependent: :destroy

  has_many :post_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #グループ機能で使う
  has_many :group_users, dependent: :destroy



  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'sample-author1.jpeg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height])
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  def favorite?(post)
    self.favorite_posts.include?(post)
  end


  GUEST_USER_EMAIL = "guest@example.com"
  
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  
  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
  
end