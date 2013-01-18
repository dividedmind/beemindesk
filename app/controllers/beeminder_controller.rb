class BeeminderController < ApplicationController
  def show
    if current_user && current_user.beeminder.nil?
      redirect_to authorization_url
    else
      redirect_to root_path
    end
  end

  def callback
    BeeminderToken.find(current_user).destroy rescue nil
    current_user.create_beeminder params.slice('access_token', 'username').merge(user: current_user)
    redirect_to root_path
  end
  
  def destroy
    current_user.beeminder.destroy
    redirect_to root_path
  end
  
  def create_goal
    current_user.beeminder.create_goal
    redirect_to root_path
  end
  
  def push_data
    current_user.push_data
    redirect_to root_path
  end
  
  private
  def authorization_url
    "https://www.beeminder.com/apps/authorize?client_id=#{client_id}&redirect_uri=#{callback_uri}&response_type=token"
  end
  
  def client_id
    @client_id ||= ENV['BEEMINDER_CLIENT_ID']
  end
  
  def callback_uri
    CGI::escape(url_for controller: 'beeminder', action: 'callback')
  end
end
