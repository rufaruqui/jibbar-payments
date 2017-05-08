class AuthService
	def self.check(token)
		response = RpcClient.new(ENV['BUNNY_GET_USER_BY_TOKEN_QUEUE'],ENV['BUNNY_GET_TOKEN_RESPONSE_QUEUE']).call({token: token})
		user = JSON.parse(response, symbolize_names: true)

		if !user.blank? && user[:success] == true
			return true
		else
			return false
		end
		
	end

	
end