class Api::V1::CustomersController < Api::V1::BaseController
	# before_action :requires_authentication_token



#list all customers
    def index
		@success = false;
        @errors = nil;

       begin 
       @stripe_customers = Stripe::Customer.list()
        
       @customers = @stripe_customers[:data]
       @success = true if @stripe_customers

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :index
    end	

#retreive a customer
    def show
    	@success = false;
        @errors = nil;

       begin 
       @stripe_customer = Stripe::Customer.retrieve(params[:id])
        
       @customer = @stripe_customer
       @success = true if @stripe_customer

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end

#create a customer
    def create_customer
    	@success = false;
        @errors = nil;


       @public_id = params[:customer][:public_id]
       params[:customer].delete :public_id

      @account = Account.find_by(:public_id=>@public_id)

      if @account.present?
          params[:customer][:id]=@account.customer;
          @customer= PaymentService.new(params[:customer]).update_customer
      else    
          @customer = PaymentService.new(params[:customer]).create_customer
      end
      
      if @customer
          @success = true;
          @errors = nil;
      end


	  render :show
    end

#update a customer
def update_customer
      @success = false;
      @errors = nil;

       @customer = PaymentService.new(params[:customer]).update_customer
       
      if @customer
          @success = true;
          @errors = nil;
      end

	  render :show
    end
#Add additional Credit Card


def add_new_card 
    	@success = false;
        @errors = nil;

       begin 
       	@stripe_customer = Stripe::Customer.retrieve(params[:id])
       	@stripe_customer.sources.create({:source => params[:source]})
       	@customer = @stripe_customer
        @success = true if @stripe_customer

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
end    

def delete_existing_card 

	    @success = false;
        @errors = nil;

       begin 
       	@stripe_customer = Stripe::Customer.retrieve(params[:id])
       	@stripe_customer.sources.retrieve(params[:source]).delete();
       	@customer = @stripe_customer
        @success = true if @stripe_customer

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show

end

#delete a customer
def delete_customer
    		@success = false;
            @errors = nil;

       begin 
       	@stripe_customer = Stripe::Customer.retrieve(params[:id])
       	@stripe_customer.delete
       	@customer = @stripe_customer
        @success = true if @stripe_customer

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
    end


#
#Get Jibbar Customer details
#
  def get_customer_details
    		@success    = true;
            @errors     = nil;
            @expired    = false;
            @cancelled  = false;
            @paused     = false;
            @handling_fee = 0.00;

            begin
                @public_id = params[:customer][:public_id]
                params[:customer].delete :public_id

             @account = Account.find_or_initialize_by(:public_id=>@public_id) if @public_id;

             if !@account.customer.nil?
                @customer     = Stripe::Customer.retrieve(@account.customer)  
               # @customer     = PaymentService.new(params[:customer]).update_customer
             else
                 @customer = Stripe::Customer.create(:email=>params[:email], :description=>params[:description]);
                 @account.customer = @customer.id
                 @account.save
             end    

            
            if  @customer.present? and !@customer.subscriptions.data.empty?
                @expired = (Time.now.to_datetime > Time.at(@customer.subscriptions.data[0].current_period_end).to_datetime )  
                @cancelled = @account.status == "cancelled" #@customer.subscriptions.data[0].cancel_at_period_end  
                @paused    = @account.status == "paused"
                @handling_fee = calculate_handling_fee( @customer.subscriptions.data[0].plan)
              
            end

            # else           
            #     @errors  = @customer.errors;
            # end        
               @success = false if  !@customer.present?

      rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

     render :customer
    end

private

     def calculate_handling_fee(plan)
         if plan.metadata.broadcasts.to_f > 0.00
           return  sprintf('%0.2f',(plan.amount.to_f/100.00) / plan.metadata.broadcasts.to_f).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
         else
           return 0.00;
         end

     end

end
