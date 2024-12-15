class CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :find_category, except: %i[create index]

  # GET /categories
  def index
    @categories = Category.all
    render json: @categories, status: :ok
  end

  # GET /categories/{categoryname}
  def show
    render json: @category, status: :ok
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    # if params[:sector_id].present?
    #   sector = Sector.where(id: params[:sector_id])

    #   @category.sector = sector
    # end
    if @category.save
      render json: @category, status: :created
    else
      render json: { errors: @category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /categories/{categoryname}
  def update
    unless @category.update(category_params)
      render json: { errors: @category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /categories/{categoryname}
  def destroy
    @category.destroy
  end

  private

  def find_category
    begin
        @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "category not found" }, status: :not_found
    end
  end

  def category_params
    params.permit(
      :name, :sector_id
    )
  end
end
