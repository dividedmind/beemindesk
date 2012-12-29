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
  end
end
