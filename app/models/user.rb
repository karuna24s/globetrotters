class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :name, presence: true
  validates :email, uniqueness: true

  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :destinations, through: :reviews
  has_many :tips

  enum role: [:user, :admin]
  def guest?
    persisted?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.email.split("@")[0].gsub(/[.]/, '')
      user.password = Devise.friendly_token[0,20]
    end      
  end
end
