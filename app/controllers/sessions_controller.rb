class SessionsController < ApplicationController
  def create
    client_id = ENV['CLIENT_ID']
    client_secret = ENV['CLIENT_SECRET']
    code = params[:code]

    conn = Faraday.new(url: 'https://github.com', headers: {'Accept': 'application/json'})

    response = conn.post('/login/oauth/access_token') do |req|
      req.params['code'] = code
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
    end

    data = JSON.parse(response.body, symbolize_names: true)
    access_token = data[:access_token]

    conn = Faraday.new(url: 'https://api.github.com', headers: { 'Authorization': "token #{access_token}" })
    response = conn.get('/user')
    user_data = JSON.parse(response.body, symbolize_names: true)

    user = User.find_or_create_by(uid: user_data[:id])
    user.username = user_data[:login]
    user.uid = user_data[:id]
    user.token = access_token
    user.save

    session[:user_id] = user.id

    redirect_to dashboard_path
  end
end
