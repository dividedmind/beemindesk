class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    !current_user.nil?
  end
  
  def current_user
    @user ||= User.find(session[:user_id]) rescue nil
  end

  def current_user=(user)
    @user = user
    session[:user_id] = user.id
    @user
  end
end
