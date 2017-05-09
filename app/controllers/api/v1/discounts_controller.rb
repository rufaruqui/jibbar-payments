 
class Api::V1::DiscountsController < Api::V1::BaseController
	# before_action :requires_authentication_token


	#delete Customer Discounts
	def delete_customer_discount
		@success = false;
        @errors = nil;

       begin 
       @discount = Stripe::Customer.retrieve(params[:id])
       @discount.delete_discount
       
       @success = true if @discount

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
	end	

   #delete Subscription discount
    def delete_subscription_discount
		@success = false;
        @errors = nil;

       begin 
       @discount = Stripe::Subscription.retrieve(params[:id]).delete_discount()
       @success = true if @discount

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
	end	
	 

end
