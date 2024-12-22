class CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :find_category, except: %i[create index]

  # GET /categories
  def index
    # Verifica se a requisição solicita paginação
    if params[:pagination].present?
      if params[:pagination] == "true"
        is_paginated_data_request = true
      else
        is_paginated_data_request = false
      end
    else
      is_paginated_data_request = false
    end

    # Constrói a consulta do ActiveRecord
    categories_query = Category.all

    if is_paginated_data_request
      # Aplica paginação antes da transformação para JSON
      paginated_categories = paginate(categories_query)

      # Converte os dados paginados para JSON
      categories_data = paginated_categories[:data].as_json(
        include: {
          items: { only: [ :id, :name, :code ] }
        },
      )

      # Retorna os dados paginados com metadados
      render json: { categories: categories_data, meta: paginated_categories[:meta] }, status: :ok
    else
      # Converte todos os setores para JSON sem paginação
      categories_data = categories_query.as_json(
        include: {
          items: { only: [ :id, :name, :code ] }
        },
      )

      # Retorna os dados completos
      render json: { categories: categories_data }, status: :ok
    end
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
