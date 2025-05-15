class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum :role, { user: 0, admin: 1 }
  
  has_many :pets, foreign_key: :owner_id, dependent: :destroy
  has_many :adoption_requests, dependent: :destroy
  has_many :received_adoption_requests, through: :pets, source: :adoption_requests
  has_many :applied_pets, through: :adoption_requests, source: :pet
  
  validates :role, presence: true
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :phone, presence: true, format: { with: /\A\+?[\d\s-]{10,}\z/, message: "must be a valid phone number" }
  validates :address, presence: true
  validates :bio, length: { maximum: 500 }
  
  after_initialize :set_default_role, if: :new_record?
  
  private
  
  def set_default_role
    self.role ||= :user
  end
end
