class Post < ApplicationRecord
  
    has_one_attached :image
    belongs_to :user
    has_many :post_comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    
    
    enum status: { draft: 0, published: 1 }
    validates :content, :status, presence: true
    validates :status, inclusion: { in: Post.statuses.keys }
    
    def toggle_status!
      if draft?
        published!
      else
        draft!
      end
    end
    
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
  
    
end
