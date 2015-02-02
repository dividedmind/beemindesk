class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one  :odesk, :class_name => "OdeskToken", :dependent => :destroy
  has_one  :beeminder, :class_name => "BeeminderToken", :dependent => :destroy
  
  def beeminder
    @beeminder ||= (super if !super.nil? && super.is_valid?)
  end
  
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
    o_dps = hours.map {|h| Beeminder::Datapoint.new value: h['hours'], timestamp: h['worked_on'] }
    bm_dps = sort_dps datapoints
    stale = []
    updated = []
    o_dps.each do |dp|
      already_there = false
      date = dp.timestamp.utc.to_date
      current = bm_dps[date] || []
      current.each do |cdp|
        if cdp == dp
          already_there = true
        else
          stale << cdp
        end
      end
      updated << dp unless already_there
      bm_dps.delete date
    end
    
    stale += bm_dps.values.flatten
    
    puts "Stale: #{pp_dps stale}"
    puts "Updated: #{pp_dps updated}"
    
    goal.add updated
    goal.delete stale
  end
  
  private
  def pp_dps dps
    dps.map { |dp| "<#{dp.timestamp.utc.to_date} #{dp.value} h>" }.join", "
  end
  
  def sort_dps datapoints
    sorted = {}
    datapoints.each do |dp|
      list = (sorted[dp.timestamp.utc.to_date] ||= [])
      list << dp
    end
    return sorted
  end
end

class Beeminder::Datapoint
  def == b
    (timestamp.utc.to_date == b.timestamp.utc.to_date) && ((value - b.value).abs < 0.1)
  end
end
