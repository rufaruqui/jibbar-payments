class Api::V1::BuyCreditsController < Api::V1::BaseController  

# retrieve all plans

	def plans_by_country
		@success = false;
        @errors = nil;

        begin
       
        @c = CountryCurrency.pluck(:country)
        
		if @c.include?(params[:country])
            @plans = BuyCredit.where(:country=>params[:country])
	    else
		    @plans = BuyCredit.where(:country=>"Others")
	    end

        #  @c= CountryCurrency.find_by(:country=>params[:country])
		# if @c.nil?
	    #    @plans = BuyCredit.where(:country=>"Others")
		# else
		#    @plans = BuyCredit.where(:country=>params[:country])
        # end

        #  if !params[:buy_credit].blank?
		#      @plans = plans.where(buy_credits_params.to_h)
		#  else
		#      @plans = plans;
		#  end
		         
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

		plans = BuyCredit.all
         if !params[:buy_credit].blank?
		     @plans = plans.where(buy_credits_params.to_h)
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

		
		if buy_credits_params.to_h.blank?
             @plan = nil;
             @errors = {:message => "No such plan" }
        else
            @plan = BuyCredit.find_by(buy_credits_params.to_h) 
            @success = true;
        end     
	
		rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end
        
        
      render :show
	end

	# create a plan /v1/CreatePlan

	def create_buy_credit
		@success = false
		@error = nil     	 
		begin 
		# creating a Jibbar Plan
		@plan  	       = BuyCredit.new( 
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
                             :validity			=> params[:validity]  
                             )
#retrieving country specific currency code to create Strip Plan
        
        currency_code 	= CountryCurrency.find_by(:country=>params[:country])

       if currency_code.nil?
       	  currency = "USD"
       else
       	  currency = currency_code.currency
       end	  
        
        @plan.currency = currency
         
	    if @plan.save
	       @success = true 
	       @plan.save

	    end    

	     
		rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @plan = nil;
		  @errors = {:message => e.message }
        end
              	 
      render :show   
	        
	end

	# update a plan /v1/UpdatePlan

	def update_buy_credit
		@success = false;
        @errors = nil;

        begin
			#retriev Jibbar plan
			@plan = BuyCredit.find_by(:id=>params[:id])

	        
			#update Jibbar plan
			if @plan
				@plan.update(buy_credits_update_params.to_h) 
				@success = true
		    end		
		  rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
        end
              	 
      render :show     	
	end

	# delete a plan /v1/DeletePlan
	def delete_buy_credit
			@success = false;
            @errors = nil;

       begin 
       @plan = BuyCredit.find_by(:id=>params[:id]) 
       @plan.delete
       
       if @plan
       	@plan.delete
       	@success = true;
       end
       	
        
       rescue => e
		  # Something else happened, completely unrelated to Stripe
		  @errors = {:message => e.message }
	  end  
     render :show
	end


	private


	def buy_credits_params
	     params.require(:buy_credit).permit :id, :name, :code, :country
	end

    def buy_credits_update_params
	     params.require(:buy_credit).permit :id, :name, :code,  :country, :price, :broadcasts, :credits, :description, :validity, :is_plan_for_team,  :display, :minimum_members, :maximum_members, :created_at, :updated_at, :validity
	end

end
