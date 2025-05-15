class AdoptionRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: [:new, :create]
  before_action :set_adoption_request, only: [:show, :update, :destroy]
  before_action :ensure_owner, only: [:update]
  before_action :ensure_requester, only: [:destroy]

  def index
    if params[:role] =='owner'
      @adoption_requests = current_user.received_adoption_requests.includes(:pet, :user).order(created_at: :desc)
      render 'index_owner'
    else
      @adoption_requests = current_user.adoption_requests.includes(:pet, :user).order(created_at: :desc)
      render 'index_requester'
    end
  end

  def show
    authorize_request_access
  end

  def new
    @adoption_request = current_user.adoption_requests.new(pet: @pet)
  end

  def create
    @adoption_request = current_user.adoption_requests.new(adoption_request_params)
    @adoption_request.pet = @pet
    @adoption_request.status = :pending

    if @adoption_request.save
      redirect_to adoption_request_path(@adoption_request), notice: 'Your adoption request has been submitted.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    case params[:status]
    when 'approved'
      if @adoption_request.approve
        redirect_to adoption_requests_path(role: 'owner'), notice: 'Adoption request has been approved.'
      else
        redirect_to adoption_requests_path(role: 'owner'), alert: 'Unable to approve the request.'
      end
    when 'rejected'
      @adoption_request.update(status: :rejected)
      redirect_to adoption_requests_path(role: 'owner'), notice: 'Adoption request has been rejected.'
    end
  end

  def destroy
    if @adoption_request.pending?
      @adoption_request.update(status: :withdrawn)
      redirect_to adoption_requests_path, notice: 'Adoption request has been withdrawn.'
    else
      redirect_to adoption_requests_path, alert: 'Cannot withdraw this request.'
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end

  def set_adoption_request
    @adoption_request = AdoptionRequest.find(params[:id])
  end

  def adoption_request_params
    params.require(:adoption_request).permit(:message)
  end

  def ensure_owner
    unless @adoption_request.pet.owner == current_user
      redirect_to adoption_requests_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def ensure_requester
    unless @adoption_request.user == current_user
      redirect_to adoption_requests_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_request_access
    unless @adoption_request.user == current_user || @adoption_request.pet.owner == current_user
      redirect_to adoption_requests_path, alert: 'You are not authorized to view this request.'
    end
  end
end 