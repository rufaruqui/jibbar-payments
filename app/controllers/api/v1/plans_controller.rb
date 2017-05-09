class Api::V1::PlansController < Api::V1::BaseController
	# before_action :requires_authentication_token
    
  # retrieve all plans
	def plans_by_country
		@success = false;
        @errors = nil;

        begin

		 @c = CountryCurrency.pluck(:country)
        
		if @c.include?(params[:country])
            @plans   = Plan.where(:country=>params[:country])
			@credits = BuyCredit.where(:country=>params[:country])
	    else
		    @plans   = Plan.where(:country=>"Others")
			@credits = BuyCredit.where(:country=>"Others")
	    end
 

        @success = true if @plans

        rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end

		render :index
	end

	# retrieve all plans

	def index
		@success = false;
        @errors = nil;

        begin

		plans = Plan.all
         if !params[:plan].blank?
		     @plans = plans.where(plans_params.to_h)
		 else
		     @plans = plans;
		 end
		         
        @success = true if @plans

        rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end

		render :index
	end



	# return a filtered plan
	def show
		@success = false;
        @errors = nil;
		

		begin 

		
		if plans_params.to_h.blank?
             @plan = nil;
             @errors = {:message => "No such plan" }
        else
            @plan = Plan.find_by(plans_params.to_h) 
            @success = true;
        end     
	
		rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end
        
        
      render :show
	end


    #return current plan of the customer identified by public id
	
	def customer_current_plan
		@success = false;
		@plan = nil;
        @errors = nil;
		
		begin 
		@account = Account.find_by(:public_id=>params[:public_id])
		if @account.plan.present?
            @plan = Plan.find_by(:code=>@account.plan) 
            @success = true;		
        end     
       
	   rescue Stripe::StripeError => e 
          body = e.json_body
		  @plan = nil;
		  @errors  = body[:error]
		rescue => e
		 @errors = {:message => e.message }
        end
        
        
      render :show
	end
	# create a plan /v1/CreatePlan

	def create_plan
		@success = false
		@error = nil

		interval_count = 1;
		interval_count = params[:interval_count] if  params[:interval_count]; 
              	 
		begin 
		# creating a Jibbar Plan
		@plan  	       = Plan.new( 
			                 :code 				=>params[:code],
			                 :name				=>params[:name],
			                 :description		=>params[:description],
			                 :credits			=>params[:credits],
			                 :broadcasts		=>params[:broadcasts],
			                 :price				=>params[:price],
			                 :country 			=>params[:country],
                             :display 			=>params[:display],
                             :minimum_members	=>params[:minimum_members],
                             :maximum_members	=>params[:maximum_members],
                             :is_plan_for_team	=>params[:is_plan_for_team],
                             :is_auto_renewable	=>params[:is_auto_renewable],
                             :interval          =>params[:interval],
                             :interval_count    =>interval_count
                             )

		#retrieving country specific currency code to create Strip Plan
        
        currency_code 	= CountryCurrency.find_by(:country=>params[:country])

       if currency_code.nil?
       	  currency = "USD"
       else
       	  currency = currency_code.currency
       end	  

        #create stripe plan, Jibbar specific unmatched data will be stored as metadata
         
        amount = @plan.price * 100;

       # if @plan.present?
           @stripe_plan 	= Stripe::Plan.create(
           									  :id 			    				=>  @plan.code, 
        	                                  :amount							=>  amount.round, 
        	                                  :currency 						=>  currency, 
        	                                  :name 							=>  @plan.name, 
        	                                  :interval							=>  @plan.interval, 
        	                                  :interval_count   				=>  @plan.interval_count,
        	                                  :metadata=>{:duration_in_days		=>	@plan.duration_in_days,
                                                          :description			=>	@plan.description,
                                                          :country 				=>	@plan.country,
                                                          :broadcasts 			=>	@plan.broadcasts,
                                                          :credits				=>	@plan.credits,
                                                          :Display 				=>	@plan.display,
                                                          :minimum_members		=>	@plan.minimum_members,
                                                          :maximum_members		=>	@plan.maximum_members,
                                                          :is_plan_for_team		=>	@plan.is_plan_for_team,
                                                          :is_auto_renewable	=>	@plan.is_auto_renewable
        	                                              }
        	                                  )
	    #end

         
        #save Strip plan id in Jibbar plan 
	    @plan.stripe_id = @stripe_plan.id
	    
	    if @stripe_plan
	       @success = true 
	       @plan.save

	    end    

	    rescue Stripe::StripeError => e
		  # Display a very generic error to the user, and maybe send
		  # yourself an email
          body = e.json_body
		  @plan = nil;
		  @errors  = body[:error]
		rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @plan = nil;
		  @errors = {:message => e.message }
        end
              	 
      render :show   
	        
	end

	# update a plan /v1/UpdatePlan

	def update_plan
		@success = false;
        @errors = nil;

        begin
			#retriev Jibbar plan
			@plan = Plan.find_by(:id=>params[:id])

	        
			#update Jibbar plan
			@plan.update(plans_update_params.to_h) if @plan

         
		   #retrieve Stripe Plan
		   @stripe_plan = Stripe::Plan.retrieve(@plan.stripe_id) if @plan;
	       
	       #update Stripe plan. Stripe allows only individual fields to be updated.
	        @stripe_plan.name                           =  params[:name]  		    if params[:name];  
            @stripe_plan.metadata[:duration_in_days]	=  @plan.duration_in_days 	if params[:duration_in_days]
            @stripe_plan.metadata[:description	   ]	=  @plan.description      	if params[:description]
            @stripe_plan.metadata[:country 	   ]	    =  @plan.country  			if params[:country]
            @stripe_plan.metadata[:broadcasts 	   ]	=  @plan.broadcasts 		if params[:broadcasts]
            @stripe_plan.metadata[:credits 	   ]	    =  @plan.credits 			if params[:credits]
            @stripe_plan.metadata[:Display 	   ]	    =  @plan.display 			if params[:display]
            @stripe_plan.metadata[:minimum_members]	    =  @plan.minimum_members 	if params[:minimum_members]
            @stripe_plan.metadata[:maximum_members]	    =  @plan.maximum_members 	if params[:maximum_members]
            @stripe_plan.metadata[:is_plan_for_team]	=  @plan.is_plan_for_team 	if params[:is_plan_for_team]
            @stripe_plan.metadata[:is_auto_renewable]	=  @plan.is_auto_renewable  if params[:is_auto_renewable]


	       @success = true if  @stripe_plan.save ;

          rescue Stripe::InvalidRequestError => e
		  # Invalid parameters were supplied to Stripe's API
		  @plan = nil
		  body = e.json_body
		  @errors  = body[:error]

		  rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end
              	 
      render :show     	
	end

	# delete a plan /v1/DeletePlan
	def delete_plan
			@success = false;
            @errors = nil;

       begin 
       @plan = Plan.find_by(:id=>params[:id])
       @stripe_plan = Stripe::Plan.retrieve(@plan.stripe_id)
       @plan.delete
       @stripe_plan.delete

       @success = true if @plan.save
       rescue Stripe::StripeError => e
		  # Display a very generic error to the user, and maybe send
		  # yourself an email
         body = e.json_body
		 @errors  = body[:error]
       rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
	  end  
     render :show
	end


	private


	def plans_params
	     params.require(:plan).permit :id, :name, :code, :stripe_id, :country
	end

    def plans_update_params
	     params.require(:plan).permit :id, :name, :code, :stripe_id, :country, :price, :broadcasts, :credits, :description, :is_auto_renewable, :is_plan_for_team, :duration_in_days, :display, :minimum_members, :maximum_members, :created_at, :updated_at, :interval, :interval_count
	end

   def handle_errors
   	    err = nil      
		rescue Stripe::CardError => e
		  # Since it's a decline, Stripe::CardError will be caught
		  body = e.json_body
		  err  = body[:error]

		  puts "Status is: #{e.http_status}"
		  puts "Type is: #{err[:type]}"
		  puts "Charge ID is: #{err[:charge]}"
		  # The following fields are optional
		  puts "Code is: #{err[:code]}" if err[:code]
		  puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
		  puts "Param is: #{err[:param]}" if err[:param]
		  puts "Message is: #{err[:message]}" if err[:message]
		   
		rescue Stripe::RateLimitError => e
		  # Too many requests made to the API too quickly 
		  body = e.json_body
		  err  = body[:error]
		 
		rescue Stripe::InvalidRequestError => e
		  # Invalid parameters were supplied to Stripe's API
		  body = e.json_body
		  err  = body[:error]

		rescue Stripe::AuthenticationError => e
		  # Authentication with Stripe's API failed
		  # (maybe you changed API keys recently)
           body = e.json_body
		   err  = body[:error]
		rescue Stripe::APIConnectionError => e
		  # Network communication with Stripe failed
		  body = e.json_body
		  err  = body[:error]
		rescue Stripe::StripeError => e
		  # Display a very generic error to the user, and maybe send
		  # yourself an email
         body = e.json_body
		  err  = body[:error]
		rescue => e
		  # Something else happened, completely unrelated to Stripe
		  err = {:message => e.message }
        return err
   end 

end
