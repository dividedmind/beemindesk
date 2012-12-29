class BeeminderToken < ActiveRecord::Base
  belongs_to :user
  
  def client
    @client ||= create_client
  end
  
  def goal
    client.goal goal_name rescue nil
  end
  
  def create_goal
    client.create_goal goal_options
  end

  private
  
  def create_client
    u = Beeminder::User.new access_token, auth_type: :oauth
    class << u
      def _connection *a
        p *a
        super *a
      end
    end
    u
  end
  
  def goal_name
    'beemindesk'
  end
  
  def goal_options
    {
      slug: goal_name,
      title: "Hours on ODesk",
      goal_type: :custom,
      rate: 0,
      goaldate: 1.year.from_now.utc.to_i,
      ephem: true,
      kyoom: true,
      aggday: :last,
      steppy: true
    }
  end
end
