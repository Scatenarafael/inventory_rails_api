class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    # puts "params[:pagination] >>> #{params[:pagination].class}"

    if params[:pagination].present?
      if params[:pagination] == "true"
        is_paginated_data_request = true
      else
        is_paginated_data_request = false
      end
    else
      is_paginated_data_request = false
    end

    # Aplicar paginação diretamente em User (ActiveRecord::Relation)
    users_query = User.all

    if is_paginated_data_request
      paginated_users = paginate(users_query)
      # Transformar os usuários paginados após aplicar a paginação
      filtered_users = paginated_users[:data].map do |user|
        user.attributes.except("password_digest")
      end

      render json: { users: filtered_users, meta: paginated_users[:meta] }, status: :ok
    else
      # Transformar todos os usuários sem aplicar paginação
      filtered_users = users_query.map do |user|
        user.attributes.except("password_digest")
      end

      render json: { users: filtered_users }, status: :ok
    end
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
  end

  private

  def find_user
    begin
        @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "User not found" }, status: :not_found
    end
  end

  def user_params
    params.permit(
      :name, :username, :role, :email, :password, :password_confirmation
    )
  end
end
