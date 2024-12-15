class ItemsController < ApplicationController
  before_action :authorize_request
  before_action :find_item, except: %i[create index]

  # GET /items
  def index
    @items = Item.all
    render json: @items, status: :ok
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
