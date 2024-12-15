class SectorsController < ApplicationController
  before_action :authorize_request
  before_action :find_sector, except: %i[create index]

  # GET /sectors
  def index
    @sectors = Sector.includes(categories: :items) # Eager loading para evitar consultas N+1

    render json: @sectors.as_json(
      include: {
        categories: {
          include: { items: { only: [ :id, :name, :code ] } }, # Inclui itens e seleciona os atributos desejados
          only: [ :id, :name ] # Atributos das categorias
        }
      },
      only: [ :id, :name ] # Atributos dos setores
    ), status: :ok
  end

  # GET /sectors/{sectorname}
  def show
    render json: @sector, status: :ok
  end

  # POST /sectors
  def create
    @sector = Sector.new(sector_params)
    if @sector.save
      render json: @sector, status: :created
    else
      render json: { errors: @sector.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /sectors/{sectorname}
  def update
    unless @sector.update(sector_params)
      render json: { errors: @sector.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /sectors/{sectorname}
  def destroy
    @sector.destroy
  end

  private

  def find_sector
    begin
        @sector = Sector.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "sector not found" }, status: :not_found
    end
  end

  def sector_params
    params.permit(
      :name
    )
  end
end
