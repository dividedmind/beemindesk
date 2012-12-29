class OdeskToken < ConsumerToken
  ODESK_OPTIONS = {
    site: 'https://www.odesk.com',
    request_token_path: '/api/auth/v1/oauth/token/request',
    access_token_path: '/api/auth/v1/oauth/token/access',
    authorize_path: '/services/api/auth'
  }

  def self.consumer
    @consumer ||= create_consumer
  end

  def self.create_consumer(options = {})
    OAuth::Consumer.new credentials[:key], credentials[:secret], ODESK_OPTIONS.merge(options)
  end
  
  before_validation :create_user
  
  def create_user
    self.user ||= begin
      u = User.new
      u.id = client.user_id
      u.save!
      u
    end
  end
  
  def client
    @client ||= Client.new super
  end
  
  class Client < Oauth::Models::Consumers::SimpleClient
    def user_id
      me['user']['id']
    end
    
    def me
      @me ||= get '/api/hr/v2/users/me.json'
    end
    
    def hours
      convert_table(get(URI.escape("/gds/timereports/v1/providers/#{user_id}?tq=SELECT worked_on, hours ORDER BY worked_on DESC"))['table'])
    end
    
    private
    def convert_table table
      cols = table['cols']
      foo = table['rows'].map do |row|
        Hash[*row['c'].each_with_index.map do |c, i|
          v = convert_value c['v'], cols[i]['type']
          l = cols[i]['label']
          [l, v]
        end.flatten]
      end
    end
    
    def convert_value v, type
      case type
      when 'date'
        Date.parse(v)
      when 'number'
        v.to_f
      end
    end
  end
end
