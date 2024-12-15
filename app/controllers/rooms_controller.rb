class RoomsController < ApplicationController
  before_action :authorize_request
  before_action :find_room, except: %i[create index]

  # GET /rooms
  def index
    @rooms = Room.all
    render json: @rooms, status: :ok
  end

  # GET /rooms/{roomname}
  def show
    render json: @room, status: :ok
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      render json: @room, status: :created
    else
      render json: { errors: @room.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /rooms/{roomname}
  def update
    unless @room.update(room_params)
      render json: { errors: @room.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /rooms/{roomname}
  def destroy
    @room.destroy
  end

  private

  def find_room
    begin
        @room = Room.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "room not found" }, status: :not_found
    end
  end

  def room_params
    params.permit(
      :name
    )
  end
end
