class UsersController < ApplicationController

    before_action :authenticate!, only: [ :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)


    if @user.save
      flash[:success] = "You've created a new user."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      render new_user_path
    end
  end

    def edit
      @user = User.friendly.find(params[:id])
      authorize @user
    end



  def update
    @user = User.friendly.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to root_path(@user)
    else
      redirect_to edit_user_path(@user)
    end
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :image)
  end

end
