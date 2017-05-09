class SubscribePlan  

   def self.create(params) 
       @error = nil;
       @success = false;

        begin
           if params[:customer]
                @customer = params[:customer]
           else     
                customer = Stripe::Customer.create(
                    :email => params[:email],
                    :source  => params[:source],
                    :shipping => params[:shipping]
                  )
                  
                @customer = customer.id;
           end

          @subscription = Stripe::Subscription.create(
            :customer    => @customer,
            :plan        => params[:plan],
            :tax_percent => params[:tax_percent],
            :trial_end   => params[:trial_end] 
          )

        rescue Stripe::CardError => e
         @error = e.message 
         @success = false;  
       end   
     return @subscription  
   end   
  end