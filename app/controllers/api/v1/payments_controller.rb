module Api::V1
  class PaymentsController < ApiController
    
    
   private

   def authenticate_user
       token = bearer_token
       auth = HTTP.auth("Bearer #{token}").post("https://jibbar-sso.herokuapp.com/v1/GetUser", :json => {}).body
       response = JSON.parse(auth)
       if response["user"].blank?
             set_return_hash(false,true,"unauthorized request")
        else
             response["user"]
        end
   end

 end
end