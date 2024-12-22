class SectorsController < ApplicationController
  before_action :authorize_request
  before_action :find_sector, except: %i[create index]

  # GET /sectors
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
    sectors_query = Sector.includes(categories: :items)

    if is_paginated_data_request
      # Aplica paginação antes da transformação para JSON
      paginated_sectors = paginate(sectors_query)

      # Converte os dados paginados para JSON
      sectors_data = paginated_sectors[:data].as_json(
        include: {
          categories: {
            include: { items: { only: [ :id, :name, :code ] } },
            only: [ :id, :name ]
          }
        },
        only: [ :id, :name ]
      )

      # Retorna os dados paginados com metadados
      render json: { sectors: sectors_data, meta: paginated_sectors[:meta] }, status: :ok
    else
      # Converte todos os setores para JSON sem paginação
      sectors_data = sectors_query.as_json(
        include: {
          categories: {
            include: { items: { only: [ :id, :name, :code ] } },
            only: [ :id, :name ]
          }
        },
        only: [ :id, :name ]
      )

      # Retorna os dados completos
      render json: { sectors: sectors_data }, status: :ok
    end
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
