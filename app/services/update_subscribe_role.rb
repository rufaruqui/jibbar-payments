class UpdateSubscribeRole  
    attr_accessor :plan, :account

   def initialize(public_id, credits, broadcasts, expireon)
     @public_id  = public_id
     @credits    = credits;
     @broadcasts = broadcasts;
     @expireon   = expireon
   end 

   def update  
       p "Updating User Subscription Role:"
       p RabbitPublisher.publish(ENV['BUNNY_USER_SUBSCRIPTION_ROLE_QUEUE'],{userPublicId: @public_id,creditBalance: @credits,broadcastBalance: @broadcasts, expireon: @expireon})
       
       
        
          # @response = HTTP.post('http://jibbartest.com/api/Account', :json =>{:tenancyName =>Rails.configuration.jibbar[:host_admin_tenant], :userNameOrEmailAddress => Rails.configuration.jibbar[:host_admin_email], :password=>Rails.configuration.jibbar[:host_admin_secret]})
          # @responsehas = JSON.parse(@response.body)
          
          # p "Authentication Token: #{@responsehas["result"]}" if  @responsehas["result"]
          # p "Error: #{@responsehas["error"]["message"]}"      if  @responsehas["error"]

          # if @responsehas["result"]
          #     jibbar_url = 'http://jibbartest.com/api/services/app/userSubscriptionRole/UpdateUserRoleByPublicId';
          #     @roleupdate = HTTP.auth("Bearer " + @responsehas["result"]).post(jibbar_url, :json=>{:creditBalance=> @credits, :broadcastBalance=> @broadcasts, :subscriptionExpireOn=> @expireon, :publicId=>@public_id })
          #     @roleupdate = JSON.parse(@roleupdate.body)

          #     p 'Succesfully updated user Subscription role'if @roleupdate["success"] 
          #     p "Error: #{@roleupdate["error"]["message"]}" if  @roleupdate["error"]
          # end
   end   
  end