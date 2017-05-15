
class Api::V1::ChargesController < Api::V1::BaseController
	# before_action :requires_authentication_token


	#list of all charges
	def index
		@success = false;
        @errors = nil;

       begin 
       @stripe_charges = Stripe::Charge.list()
        
       @charges = @stripe_charges[:data]
       @success = true if @stripe_charges

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :index
	end	


	#retrieve a charge
    def show
    	 @success = false;
         @errors = nil;

       begin 
       @stripe_charge = Stripe::Charge.retrieve(params[:id])
        
       @charge = @stripe_charge
      if @stripe_charge
          @success  = true ;
          @customer = Stripe::Customer.retrieve(@stripe_charge.customer);
      end
          
       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#create a charge
    def create_charge
    	  @success = false;
        @errors = nil; 


         #Remove jibbar specific filed but not required for Stripe payment processing
        @public_id = params[:charge][:public_id]
        @validity  = params[:charge][:validity] #valids for 1 year.
        @plan      = params[:charge][:plan]

        params[:charge].delete :public_id
        params[:charge].delete :validity
        params[:charge].delete :plan


       begin 
       @stripe_charge = Stripe::Charge.create( params[:charge].to_unsafe_h ) 
       

        

     if @stripe_charge   
        @charge = @stripe_charge
        @success = true 
        
        #Update customer's subscription info and set status as pending. 
        @account = Account.find_or_initialize_by(:public_id=>@public_id)

       @account.update_attributes(
                                 :public_id     => @public_id,  
                                 :customer      => params[:customer],
                                 :plan          => @plan,
                                 :status        => "pending",
                                #  :active_until  => Time.now.to_datetime + 730, #@validity,
                                 :recurrent     => false,
                                 :stripe_charge => @stripe_charge.id
                                # :stripe_subscription =>nil
                                 )
      

       end


       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#update a charge
    def update_charge
    	@success = false;
        @errors = nil;

       begin  
        @stripe_charge = Stripe::Charge.retrieve(params[:id])
       
        @stripe_charge.description    = params[:description]                    if params[:description]
        @stripe_charge.receipt_email  = params[:receipt_email]                  if params[:receipt_email]
        @stripe_charge.shipping       = params[:shipping].to_unsafe_h           if params[:shipping]
        @stripe_charge.metadata       = params[:metadata].to_unsafe_h           if params[:metadata]
        @stripe_charge.fraud_details  = params[:fraud_details].to_unsafe_h      if params[:fraud_details]
          
       
       @stripe_charge.save
       @charge = @stripe_charge
       @success = true if @stripe_charge

       rescue Stripe::StripeError => e 
         body = e.json_body
		     @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

	#capture a charge
    def capture_charge
    		@success = false;
        @errors = nil;

       begin 
       	@stripe_charge = Stripe::Charge.retrieve(params[:id])
       	@stripe_charge.capture
       	@charge = @stripe_charge
        @success = true if @stripe_charge

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
    end

   #List of all "succefull" charges by customer id

   #list of all charges
	def succeeded_charge_list
		@success = false;
        @errors = nil;
        @public_id = params[:charge][:public_id]
        params[:charge].delete :public_id
       
        begin 
        #Retreiving stripe customer id from Account
        @account = Account.find_by(:public_id=>@public_id)
       p @account
       if @account 
        #Retreiving stripe invoices.
         @stripe_charges = Stripe::Charge.list(:status=>params[:status], :customer=>@account.customer)
         
         @charges = @stripe_charges[:data]
         p @charges
         @success = true if @stripe_charges
      end   

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :list
	end	


   def get_receipt()
            @success = false;
            @errors = nil;

            @price = 0.00;
            @gst   = 0.00;

            begin     
            @charge  = Stripe::Charge.retrieve(params[:id])
            @customer = Stripe::Customer.retrieve(@charge.customer)
            @amount = format_amount(@charge.amount)
            if @charge.application_fee.nil?
                @fee = nil
            else      
               @fee  = format_amount(@charge.application_fee)
            end
            
            if @charge
                @success = true 
                @price   = @charge.metadata.price if @charge.metadata.price;
                @gst   = @charge.metadata.gst if @charge.metadata.gst;
            end    
                

            rescue Stripe::StripeError => e
                body = e.json_body
                @errors  = body[:error] if body
            rescue => e
                @errors = {:message => e.message }
            end  

            render :receipt
   end


   def format_amount(amount)
        sprintf('%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end

   def format_amount1(amount)
        sprintf('%0.2f', amount.to_f).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end

   def format_stripe_timestamp(timestamp)
        Time.at(timestamp).strftime("%m/%d/%Y")
   end

 

end
