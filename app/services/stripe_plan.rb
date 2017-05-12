class StripePlan
	def self.update(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)

		if(json_msg[:action] == "create")
			  create_plan(json_msg[:params]);
	    elsif(json_msg[:action] == "update")	
			  update_plan(json_msg[:params]);	  
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
		p plan_parms
	    retHash = Hash.new 
	    retHash["success"] = false
	    retHash["error"]   =  ""
	    retHash["result"]  =  nil

		begin 
		@stripe_plan = Stripe::Plan.retrieve(plan_parms[:id])
		@stripe_plan.update_attributes(plan_parms)
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

end