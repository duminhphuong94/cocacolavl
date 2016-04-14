class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :entries, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                 foreign_key: "follower_id",
                                 dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true
  has_many :comments, dependent: :destroy
  #likes
  has_many :likes,dependent: :destroy
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Entry.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def allowed_user
    sqlstring = "SELECT follower_id FROM relationships WHERE  followed_id = :user_id"
    User.where("id IN (#{sqlstring}) OR id = :user_id", user_id: id)
  end

  def allowed_user2
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    User.where("id IN (#{following_ids})")
  end

   # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  #like entry
  def like(entry)
    likes.create(entry_id: entry.id)
  end
  
  #unlike entry
  def unlike(entry)
    likes.find_by(entry_id: entry.id).destroy
  end
  #liked entries
  def liked_entries
    liked_entries_ids = "SELECT entry_id FROM likes
                     WHERE  user_id = :user_id"
    Entry.where("id IN (#{liked_entries_ids})", user_id: id)
  end
  #like entry?
  def liked?(entry)
    liked_entries.include?(entry)
  end
  #toggle like/unlike
  def like_toggle(entry)
    user.liked?(entry)? user.unlike(entry): user.like(entry)
  end
    



  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

end
