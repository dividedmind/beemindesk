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
  
  def total_hours
    hours.map {|x| x['hours']}.sum
  end
  
  def total_days
    hours.first['worked_on'] - hours.last['worked_on'] + 1
  end
  
  def days_till_now
    Date.today - hours.last['worked_on'] + 1
  end
  
  def ok_to_push
    odesk && beeminder && beeminder.goal_ok?
  end
  
  def push_data
    return unless ok_to_push
    dps = hours.reverse.map {|h| Beeminder::Datapoint.new value: h['hours'], timestamp: h['worked_on'] }
    dps.delete_if {|dp| already_pushed? dp }
    goal.add dps
  end
  
  private
  def already_pushed? dp
    datapoints.index do |d| 
      (d.timestamp.to_date == dp.timestamp.to_date) && ((d.value - dp.value).abs < 0.1)
    end
  end
end
