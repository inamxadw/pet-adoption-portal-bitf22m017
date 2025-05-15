class Pet < ApplicationRecord
  enum :status, { available: 0, pending: 1, adopted: 2 }
  
  belongs_to :owner, class_name: 'User'
  has_many :adoption_requests, dependent: :destroy
  has_many :users, through: :adoption_requests
  has_one_attached :image
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :species, presence: true
  validates :breed, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 30, maximum: 1000 }
  validates :status, presence: true
  validates :image, presence: true, on: :create
  
  scope :available, -> { where(status: :available) }
  scope :by_species, ->(species) { where(species: species) }
  scope :by_breed, ->(breed) { where(breed: breed) }
  
  def self.species_list
    distinct.pluck(:species).sort
  end
  
  def self.breed_list
    distinct.pluck(:breed).compact.sort
  end

  def self.common_species
    ['Dog', 'Cat', 'Bird', 'Rabbit', 'Hamster', 'Fish']
  end

  def pending_requests
    adoption_requests.pending
  end

  def has_pending_request_from?(user)
    pending_requests.exists?(user: user)
  end

  def mark_as_adopted!
    update!(status: :adopted)
  end
end
