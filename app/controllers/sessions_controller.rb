class SessionsController < ApplicationController

  def new
  end

  def create

    # user = User.find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    # if user && user.authenticate(params[:password])
    #   session[:user_id] = user.id
    #   redirect_to '/events'
    # else
    #   flash[:alert] = "There was an error with your credentials. Please Try again."
    #   redirect_to '/login'
    # end

    if request.env['omniauth.auth']
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to '/events'
    else
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to '/events'
      else
       redirect_to '/'
      end
    end
  end



  def destroy
    session.delete(:user_id)
    redirect_to '/'
  end

end