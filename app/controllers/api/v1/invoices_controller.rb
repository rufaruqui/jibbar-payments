class Api::V1::InvoicesController < Api::V1::BaseController 
   
   	#list of all invoices
	def index
		@success = false;
        @errors = nil;

       begin 
        @public_id = params[:invoice][:public_id]
        params[:invoice].delete :public_id

        #Retreiving stripe customer id from Account
        @account = Account.find_by(:public_id=>@public_id)

       if @account 
        #Retreiving stripe invoices.
        @stripe_invoices = Stripe::Invoice.list(:customer=>@account.customer) if @account
        @invoices = @stripe_invoices[:data]
        @success = true if @stripe_invoices 
       else
           @errors = {:message => "No invoices found"}
       end

	  end  
     render :index
	end	

 
   
	#retrieve a invoice
    def show
    	@success = false;
        @errors = nil;

       begin 
       @stripe_invoice = Stripe::Invoice.retrieve(params[:id])
       @invoice = @stripe_invoice

       if @invoice.lines.data[0].type == "subscription"
           @subscription = Stripe::Subscription.retrieve(id: @invoice.lines.data[0].id, expand: ['customer']) 
           @period_start = Time.at(@subscription.current_period_start).getutc.strftime("%m/%d/%Y")
           @period_end   = Time.at(@subscription.current_period_end).getutc.strftime("%m/%d/%Y")
           @description = "Subcription to the plan :" + @subscription.plan.name + " Valid from " + @period_start + " to " + @period_end + ". [ Credits: "+ 
           @subscription.plan.metadata.credits + " Broadcasts: "+ @subscription.plan.metadata.broadcasts + " ]"
           @customer         = @subscription.customer    
       end
    
       @amount = format_amount(@invoice.amount_due)
       @total  = format_amount(@invoice.total)
       @success = true if @stripe_invoice

       rescue Stripe::StripeError => e
		  body = e.json_body
		 @errors  = body[:error] if body
       rescue => e
		 @errors = {:message => e.message }
	  end  

	  render :show
    end    
    

 def generate_invoice()
   # Retrieve the event from Stripe
    @event = Stripe::Event.retrieve(params[:id]) 
    if @event.type.eql?('invoice.payment_succeeded')
    # Send a receipt for the invoice 
       unless @event.data.object.subscription.nil?
      
      # Retrieve the subscription
      @subscription = Stripe::Subscription.retrieve(id: @event.data.object.subscription, expand: ['customer'])

      # Format the period start and end dates
      @period_start = Time.at(@subscription.current_period_start).getutc.strftime("%m/%d/%Y")
      @period_end   = Time.at(@subscription.current_period_end).getutc.strftime("%m/%d/%Y")
    end   
   end 
 render :html_email 
end 

    def format_amount(amount)
        sprintf('%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    end

    def format_stripe_timestamp(timestamp)
        Time.at(timestamp).strftime("%m/%d/%Y")
    end

 helper_method :format_amount
 helper_method :format_stripe_timestamp

   
    
end
