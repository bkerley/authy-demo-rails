class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by name: params[:name]
    return fail unless @user

    return fail unless @user.authenticate params[:password]

    @authy = Authy::API.verify id: @user.authy_id, token: params['authy-token']

    return fail unless @authy.ok?
      
    session[:user_id] = @user.id
    flash.clear

    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private
  def fail
    flash[:alert] = 'nope'
    render action: 'new'
  end
end
