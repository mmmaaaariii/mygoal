class Post < ApplicationRecord

    has_one_attached :image
    belongs_to :user
    has_many :post_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy

    validates :title, :content, presence: true

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(search)
    if search
      where('title LIKE ? OR content LIKE ? OR user_id IN (SELECT id FROM users WHERE name LIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      all
    end
  end
  
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%'+content)
    else
      Post.where('title LIKE ?', '%'+content+'%')
    end
  end


end
