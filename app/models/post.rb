class Post < ApplicationRecord
    enum status: { draft: 0, published: 1 }
    validates :title, :content, :status, presence: true
    validates :status, inclusion: { in: Post.statuses.keys }
    
    def toggle_status!
      if draft?
        published!
      else
        draft!
      end
    end
  
    has_one_attached :image
    belongs_to :user
    
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end
    
end
