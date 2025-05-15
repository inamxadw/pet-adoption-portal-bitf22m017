class AdoptionApplication < ApplicationRecord
  belongs_to :user
  belongs_to :pet
  
  enum :status, { pending: 0, approved: 1, rejected: 2 }
  
  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :pet_id, message: "has already applied for this pet" }
  validate :pet_must_be_available, on: :create
  
  after_initialize :set_default_status, if: :new_record?
  after_save :update_pet_status
  
  private
  
  def set_default_status
    self.status ||= :pending
  end
  
  def pet_must_be_available
    if pet.present? && !pet.available?
      errors.add(:pet, "is not available for adoption")
    end
  end
  
  def update_pet_status
    if approved?
      pet.update(status: :adopted)
    elsif rejected? && pet.pending?
      pet.update(status: :available)
    elsif pending?
      pet.update(status: :pending)
    end
  end
end
