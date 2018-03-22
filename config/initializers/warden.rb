Warden::Strategies.add(:password) do
  def valid?
    session && session['email'] && session['password']
  end

  def session
    params['session'] || {}
  end

  def authenticate!
    user = User.find_by(email: session['email'])
    if user&.authenticate(session['password'])
      success! user
    else
      fail "Invalid email or password"
    end
  end
end

Warden::Strategies.add(:token) do
  def valid?
    params['token']
  end

  def authenticate!
    user = User.find_by(token: params['token'])
    if user
      success! user
    else
      fail "Invalid token"
    end
  end
end

Rails.application.config.middleware.insert_after ActionDispatch::Flash, Warden::Manager do |config|
  config.failure_app = ->(env) { SessionsController.action(:new).call(env) }
  config.default_strategies :password
end

Warden::Manager.serialize_into_session(&:id)

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end
