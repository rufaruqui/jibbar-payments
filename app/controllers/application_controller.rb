class ApplicationController < ActionController::API
  def bearer_token
	  pattern = /^Bearer /
	  header  = request.headers["Authorization"] #request.env["Authorization"] # <= env
	  header.gsub(pattern, '') if header && header.match(pattern)

  end

  def get_public_id
  	  SecureRandom.urlsafe_base64(16)
  end

  def get_client_app_base_url
  	ENV['CLIENT_APP']
  end

  def get_view_app_base_url
    ENV['VIEWER_APP']
  end
end
