class StripePlan
	def self.update(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)

		if(json_msg[:action] == "create")
			  create_plan(json_msg[:params]);
	    elsif(json_msg[:action] == "update")	
			  update_plan(json_msg[:params]);	
	    elsif(json_msg[:action] == "delete")	
			  delete_plan(json_msg[:params]);		    
		end

	end

    
	def self.create_plan(plan_parms)
	    retHash = Hash.new 
	    retHash["success"] = true
	    retHash["error"]   =  ""
	    retHash["result"]  =  nil
		
		begin 
		@result = Stripe::Plan.create(plan_parms)
	    retHash["result"] = @result if @result;

	   rescue Stripe::StripeError => e 
         body = e.json_body
		 retHash["error"]   = body[:error]
		 retHash["success"] = false;
       rescue => e 
		 retHash["error"]  = {:message => e.message }
		 retHash["success"] = false;
	   end  	 
	   return retHash.to_json;
    end

	def self.update_plan(plan_parms) 
	    retHash = Hash.new 
	    retHash["success"] = false
	    retHash["error"]   =  ""
	    retHash["result"]  =  nil

		begin 
		  @stripe_plan = Stripe::Plan.retrieve(plan_parms[:id]) 
	       #update Stripe plan. Stripe allows only individual fields to be updated.
	        @stripe_plan.name                           =  plan_parms[:name]  		        if plan_parms[:name];  
            @stripe_plan.metadata[:duration_in_days]	=  plan_parms[:duration_in_days] 	if plan_parms[:duration_in_days]
            @stripe_plan.metadata[:description	   ]	=  plan_parms[:description]     	if plan_parms[:description]
            @stripe_plan.metadata[:country 	   ]	    =  plan_parms[:country] 			if plan_parms[:country]
            @stripe_plan.metadata[:broadcasts 	   ]	=  plan_parms[:broadcasts] 		    if plan_parms[:broadcasts]
            @stripe_plan.metadata[:credits 	   ]	    =  plan_parms[:credits]			    if plan_parms[:credits]
            @stripe_plan.metadata[:Display 	   ]	    =  plan_parms[:display]			    if plan_parms[:display]
            @stripe_plan.metadata[:minimum_members]	    =  plan_parms[:minimum_members]	    if plan_parms[:minimum_members]
            @stripe_plan.metadata[:maximum_members]	    =  plan_parms[:maximum_members]	    if plan_parms[:maximum_members]
            @stripe_plan.metadata[:is_plan_for_team]	=  plan_parms[:is_plan_for_team]    if plan_parms[:is_plan_for_team]
            @stripe_plan.metadata[:is_auto_renewable]	=  plan_parms[:is_auto_renewable]   if plan_parms[:is_auto_renewable]


		 retHash["success"] = true if  @stripe_plan.save;
		@result =  @stripe_plan
	    retHash["result"] = @result if @result;

	   rescue Stripe::StripeError => e 
         body = e.json_body
		 retHash["error"]   = body[:error]
		 retHash["success"] = false;
       rescue => e 
		 retHash["error"]  = {:message => e.message }
		 retHash["success"] = false;
	   end  	 
	   return retHash.to_json;
    end

	def self.delete_plan(plan_parms) 
	    retHash = Hash.new 
	    retHash["success"] = false
	    retHash["error"]   =  ""
	    retHash["result"]  =  nil

		begin 
		@stripe_plan = Stripe::Plan.retrieve(plan_parms[:id])
		retHash["success"] = true if  @stripe_plan.delete;
		@result =  @stripe_plan
	    retHash["result"] = @result if @result;

	   rescue Stripe::StripeError => e 
         body = e.json_body
		 retHash["error"]   = body[:error]
		 retHash["success"] = false;
       rescue => e 
		 retHash["error"]  = {:message => e.message }
		 retHash["success"] = false;
	   end  	 
	   return retHash.to_json;
    end

end