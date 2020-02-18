class Api::V1::UsersController < ApplicationController

  SLACK_API_TOKEN = "xoxb-843568960375-867449413506-41hdhOLmF8OxaeEtFeSvbEf2"
  SPOTIFY_CLIENT_ID = "80a4b6a4fb4f4add9b6a8289eb936864"
  SPOTIFY_CLIENT_SECRET = "4542e9e43c5845ee8fae652b24ebffe9"

  def create
    if params[:errors]
      puts "Login Failed"
    else
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: 'http://12a74d38.ngrok.io/api/v1/user',
        client_id: SPOTIFY_CLIENT_ID,
        client_secret: SPOTIFY_CLIENT_SECRET
      }

      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      auth_params = JSON.parse(auth_response.body)
      p auth_params
      header = {
        Authorization: "Bearer #{auth_params["access_token"]}" 
      }

      user_response = RestClient.get('https://api.spotify.com/v1/me', header)
      user_params = JSON.parse(user_response.body)
      p user_params
      @user = User.find_for_spotify(
        spotify_id: user_params["id"],
        email: user_params["email"],
        access_token: auth_params["access_token"],
        refresh_token: auth_params["refresh_token"]
      )
    end
    
  end

end