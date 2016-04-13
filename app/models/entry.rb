class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes,dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true,length: {maximum: 30}
  validates :body,presence: true,length: {maximum: 140}
  validates :picture,presence: true
  
  def liked_users
    liked_users_ids = "SELECT user_id FROM likes
                     WHERE  entry_id = :entry_id"
    User.where("id IN (#{liked_users_ids})", entry_id: id)
  end
  
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
