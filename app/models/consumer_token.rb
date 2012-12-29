require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token

  before_validation :create_user
  
  def create_user
    self.user ||= User.create
  end

  # Modify this with class_name etc to match your application
  belongs_to :user

end
