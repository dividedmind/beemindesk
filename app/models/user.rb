class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one  :odesk, :class_name => "OdeskToken", :dependent => :destroy
  has_one  :beeminder, :class_name => "BeeminderToken", :dependent => :destroy
  
  def hours
    @hours ||= odesk.client.hours
  end
  
  def goal
    @goal ||= beeminder.goal
  end
  
  def datapoints
    @datapoints ||= goal.datapoints
  end
end
