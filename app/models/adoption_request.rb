class AdoptionRequest < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  enum :status, { pending: 0, approved: 1, rejected: 2, withdrawn: 3 }

  validates :message, presence: true, length: { minimum: 50, maximum: 1000 }
  validates :status, presence: true
  validate :cannot_adopt_own_pet
  validate :no_pending_request_for_same_pet
  validate :pet_must_be_available, on: :create

  private

  def cannot_adopt_own_pet
    if user == pet.owner
      errors.add(:base, "You cannot adopt your own pet")
    end
  end

  def no_pending_request_for_same_pet
    if user.adoption_requests.pending.where(pet: pet).where.not(id: id).exists?
      errors.add(:base, "You already have a pending request for this pet")
    end
  end

  def pet_must_be_available
    unless pet.available?
      errors.add(:pet, "is not available for adoption")
    end
  end
end
