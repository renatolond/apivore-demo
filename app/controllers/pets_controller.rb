class PetsController < ApplicationController
  before_action :validate_pet_id, only: [:show, :update, :destroy]
  before_action :set_pet, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    render json: {error: "PET_NOT_FOUND", message: "A pet with this id was not found"}, status: :not_found
  end

  class InvalidPetId < StandardError; end

  rescue_from InvalidPetId do
    render json: {error: "INVALID_ID_ERROR", message: "An id can only contain numbers"}, status: :bad_request
  end

  rescue_from Pet::NameTaken do
    render json: {error: "PET_ALREADY_EXISTS", message: "A pet with this name is already available for donation"}, status: :conflict
  end

  # GET /pets
  def index
    @pets = Pet.all

    render json: @pets
  end

  # GET /pets/1
  def show
    render json: @pet
  end

  # POST /pets
  def create
    @pet = Pet.new(pet_params)

    if @pet.save
      render json: @pet, status: :created, location: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pets/1
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pets/1
  def destroy
    @pet.destroy
  end

  private

    def validate_pet_id
      if params[:id].match?(/[^0-9]/)
        raise InvalidPetId
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pet_params
      params.require(:pet).permit(:name, :status, photo_urls: [])
    end
end
