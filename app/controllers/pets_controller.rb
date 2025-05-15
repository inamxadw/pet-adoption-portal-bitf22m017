class PetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_pet, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @pets = Pet.available.includes(:owner, image_attachment: :blob).order(created_at: :desc)
    
    if params[:species].present?
      @pets = @pets.by_species(params[:species])
    end
    
    if params[:breed].present?
      @pets = @pets.by_breed(params[:breed])
    end

    if params[:min_age].present?
      @pets = @pets.where('age >= ?', params[:min_age])
    end

    if params[:max_age].present?
      @pets = @pets.where('age <= ?', params[:max_age])
    end

    # Get unique breeds for filter dropdown
    @breeds = Pet.breed_list
    
    # Add pagination
    @pagy, @pets = pagy(@pets, items: 12)
  end

  def show
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = current_user.pets.build(pet_params)
    @pet.status = :available

    if @pet.save
      redirect_to @pet, notice: 'Pet was successfully posted for adoption.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pet.update(pet_params)
      redirect_to @pet, notice: 'Pet listing was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_url, notice: 'Pet listing was successfully removed.'
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:name, :species, :breed, :age, :description, :image)
  end

  def ensure_owner
    unless @pet.owner == current_user
      redirect_to pets_path, alert: 'You are not authorized to perform this action.'
    end
  end
end 