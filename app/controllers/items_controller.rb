class ItemsController < ApplicationController
  before_action :authorize_request
  before_action :find_item, except: %i[create index]

  # GET /items
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
    items_query = Item.includes(:user, :room, :category)

    if is_paginated_data_request
      # Aplica paginação diretamente na consulta ActiveRecord
      paginated_items = paginate(items_query)

      # Transforma os dados paginados em JSON e remove atributos indesejados
      filtered_items = paginated_items[:data].map do |item|
        item.as_json(
          include: {
            user: { only: [ :name ] },
            room: { only: [ :name ] },
            category: { only: [ :id, :name ] }
          }
        ).except("user_id", "category_id", "room_id")
      end

      # Retorna os dados paginados com metadados
      render json: { items: filtered_items, meta: paginated_items[:meta] }, status: :ok
    else
      # Transforma todos os itens em JSON e remove atributos indesejados
      filtered_items = items_query.map do |item|
        item.as_json(
          include: {
            user: { only: [ :name ] },
            room: { only: [ :name ] },
            category: { only: [ :id, :name ] }
          }
        ).except("user_id", "category_id", "room_id")
      end

      # Retorna os dados completos
      render json: { items: filtered_items }, status: :ok
    end
  end


  # GET /items/{itemname}
  def show
    render json: @item, status: :ok
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    # if params[:sector_id].present?
    #   sector = Sector.where(id: params[:sector_id])

    #   @item.sector = sector
    # end
    if @item.save
      render json: @item, status: :created
    else
      render json: { errors: @item.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /items/{itemname}
  def update
    unless @item.update(item_params)
      render json: { errors: @item.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /items/{itemname}
  def destroy
    @item.destroy
  end

  private

  def find_item
    begin
        @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "item not found" }, status: :not_found
    end
  end

  def item_params
    params.permit(
      :name, :code, :category_id, :room_id, :user_id
    )
  end
end
