class HomeController < ApplicationController
  def index
    # Load featured pets for the homepage
    @featured_pets = Pet.available
                       .includes(:owner, image_attachment: :blob)
                       .order(created_at: :desc)
                       .limit(6)
  end
end
