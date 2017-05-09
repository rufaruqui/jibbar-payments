json.result do
    if !@customer.nil? 
        json.Customer do
           json.stripe_customer_id @customer.id
           json.default_source     @customer.default_source
           json.shipping           @customer.shipping 
           if !@customer.subscriptions.data.empty?
            json.status             @account.status
            json.plan               @customer.subscriptions.data[0].items.data[0].plan
            json.handling_fee       @handling_fee
            json.isExpired          @expired
            json.isCancelled        @cancelled
            json.isPuased           @paused
            json.subscriptions_id   @customer.subscriptions.data[0].id
           end     
           
           if @customer.subscriptions.data.empty?
            json.status            @account.status
            json.plan              @account.plan
            json.isExpired         @expired
            json.isCancelled       @cancelled
            json.subscriptions_id  nil
           end     

        end
    
        json.Card @customer.sources.data.each do |card|  
                json.id   card.id
                json.name card.name
                json.type card.brand
                json.last4 card.last4
                json.exp_month card.exp_month
                json.exp_year card.exp_year
        end
    
        
           
   end
   
   if @customer.nil? 
        json.Customer nil
        json.Card     nil
   end

end        
json.success  @success
json.errors   @errors     