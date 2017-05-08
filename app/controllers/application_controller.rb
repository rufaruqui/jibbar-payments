class ApplicationController < ActionController::API
  def bearer_token
	  pattern = /^Bearer /
	  header  = request.headers["Authorization"] #request.env["Authorization"] # <= env
	  header.gsub(pattern, '') if header && header.match(pattern)

  end

  def authenticate_user
    return AuthService.check(bearer_token)
  end
end
