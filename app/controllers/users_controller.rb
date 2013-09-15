class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params

    return fail 'user not valid' unless @user.valid?

    @authy = Authy::API.register_user(
                                      email: @user.name, 
                                      cellphone: params[:cellphone], 
                                      country_code: params[:country_code]
                                      )

    return fail "Authy failed :(" unless @authy.ok?

    @user.authy_id = @authy.id

    return fail "couldn't save" unless @user.save

    session[:user_id] = @user.id

    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit %i{name password password_confirmation}
  end

  def fail(message)
    flash[:alert] = message
    render action: 'new'
  end
end
