class BeeminderToken < ActiveRecord::Base
  belongs_to :user
  
  def client
    @client ||= create_client
  end
  
  def goal
    @goal ||= client.goal goal_name rescue nil
  end
  
  def create_goal
    client.create_goal goal_options
  end
  
  def is_valid?
    me = client.get('/users/me.json')
    unless username
      self.username = me['username']
      save
    end
    true
  rescue
    false
  end
  
  def goal_ok?
    return unless goal
    goal.instance_variable_get(:@kyoom)
  end

  private
  
  def create_client
    Beeminder::User.new access_token, auth_type: :oauth
  end
  
  def goal_name
    'beemindesk'
  end
  
  def goal_options
    {
      slug: goal_name,
      title: "Hours on ODesk",
      goal_type: :custom,
      goaldate: 1.year.from_now.utc.to_i,
      ephem: true,
      kyoom: true,
      aggday: :last,
      steppy: true,
      rate: calculate_rate
    }
  end
  
  def calculate_rate
    user.total_hours / user.days_till_now * 7
  end
end
