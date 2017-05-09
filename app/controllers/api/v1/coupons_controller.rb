
class Api::V1::CouponsController < Api::V1::BaseController
	# before_action :requires_authentication_token


	#list of all coupons
	def index
		@success = false;
        @errors = nil;

       begin 
       @stripe_coupons = Stripe::Coupon.list()
        
       @coupons = @stripe_coupons[:data]
       @success = true if @stripe_coupons

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :index
	end	


	#retrieve a coupon
    def show
    	@success = false;
        @errors = nil;

       begin 
       @stripe_coupon = Stripe::Coupon.retrieve(params[:id])
        
       @coupon = @stripe_coupon
       @success = true if @stripe_coupon

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#create a coupon
    def create_coupon
    	@success = false;
        @errors = nil;

       begin 
       @stripe_coupon = Stripe::Coupon.create( params[:coupon].to_unsafe_h )
                                               # :id           		=> params[:id],
       	                                       # :percent_off  		=> params[:percent_off],
       	                                       # :duration     		=> params[:duration],
       	                                       # :duration_in_months 	=> params[:duration_in_months],
       	                                       # :amount_off			=> params[:amount_off],
       	                                       # :currency      		=> params[:currency],
       	                                       # :max_redemptions     => params[:max_redemptions],
       	                                       # :metadata            => params[:metadata],
       	                                       # :redeem_by			=> params[:redeem_by]
       	                                       # )
        


       @coupon = @stripe_coupon
       @success = true if @stripe_coupon

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#update a coupon
    def update_coupon
    	@success = false;
        @errors = nil;

       begin 
       @stripe_coupon = Stripe::Coupon.retrieve(params[:id])
       @stripe_coupon.metadata =  params[:metadata].to_unsafe_h if params[:metadata]
         
       @stripe_coupon.save
       @coupon = @stripe_coupon
       @success = true if @stripe_coupon

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#delete a coupon
    def delete_coupon
    		@success = false;
            @errors = nil;

       begin 
       	@stripe_coupon = Stripe::Coupon.retrieve(params[:id])
       	@stripe_coupon.delete
       	@coupon = @stripe_coupon
        @success = true if @stripe_coupon

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
    end

end
