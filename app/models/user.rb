class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one  :odesk, :class_name => "OdeskToken", :dependent => :destroy
  has_one  :beeminder, :class_name => "BeeminderToken", :dependent => :destroy
  
  def hours
    odesk.client.hours
  end
end
