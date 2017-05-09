class PaymentService
  def initialize(_params)
    @params = _params;
  end

  def charge
    begin 
      external_charge_service.create(@params)
    rescue
      false
    end
  end

  def create_subscription
      external_subscription_service.create(subscription_attributes)
  end

  def update_customer
     begin
      update_stripe_customer 
       rescue Stripe::StripeError => e
         @error = e.message  
    end  
  end

 def update_subscription
    begin
      update_stripe_subscription
         rescue Stripe::StripeError => e
         @error = e.message  
    end
  end

  def create_customer
    begin 
      external_customer_service.create(@params) 
    rescue Stripe::CardError => e
         @error = e.message  
    end
  end

  def subscribe_jibbar_plan
      if params[:customer]
          create_subscription
      else   
          @customer =   external_customer_service.create(@params) 
          @params[:customer]=@customer.id;
          create_subscription
      end

  end


  private

  attr_reader :params

  def external_charge_service
    Stripe::Charge
  end

  def external_customer_service
    Stripe::Customer
  end

   def external_subscription_service
    Stripe::Subscription
  end

   def update_stripe_customer 
   
            @stripe_customer = Stripe::Customer.retrieve(params[:id])
            
            @stripe_customer.account_balance = params[:account_balance] if params[:account_balance]
            @stripe_customer.business_vat_id = params[:business_vat_id] if params[:business_vat_id]
            @stripe_customer.coupon          = params[:coupon]          if params[:coupon]
            @stripe_customer.default_source  = params[:default_source]  if params[:default_source]
            @stripe_customer.description     = params[:description]     if params[:description]
            @stripe_customer.email           = params[:email]           if params[:email] 

            @stripe_customer.source          = params[:source]               if params[:source]
            @stripe_customer.shipping        = params[:shipping].to_unsafe_h if params[:shipping]
            @stripe_customer.metadata        = params[:metadata].to_unsafe_h if params[:metadata]

            @stripe_customer.save
             
       return   @stripe_customer   
 end

 def update_stripe_subscription
       p params;
       @stripe__subscription = Stripe::Subscription.retrieve(params[:id])
       p @stripe__subscription
       p "updating......."
       @stripe__subscription.application_fee_percent = params[:application_fee_percent] if params[:application_fee_percent]
       @stripe__subscription.coupon                  = params[:coupon]                  if params[:coupon]
       @stripe__subscription.plan 				        	 = params[:plan] 				            if params[:plan]
       @stripe__subscription.prorate 			        	 = params[:prorate]                 if params[:prorate]
       @stripe__subscription.proration_date          = params[:proration_date]          if params[:proration_date]
       @stripe__subscription.quantity                = params[:quantity]			          if params[:quantity]
       @stripe__subscription.tax_percent             = params[:tax_percent]             if params[:tax_percent]
       @stripe__subscription.trial_end               = params[:trial_end]               if params[:trial_end]
       @stripe__subscription.metadata                = params[:metadata].to_unsafe_h    if params[:metadata]
       @stripe__subscription.source                  = params[:source].to_unsafe_h      if params[:source]
       @stripe__subscription.items                   = params[:items].to_unsafe_h       if params[:items]
       
       @stripe__subscription.save 

       return @stripe__subscription
end

#   def charge_attributes
#     {
#       amount: @params[:amount],
#       card: @params[:card]
#     }
#   end

   def subscription_attributes
     {
        :customer     =>params[:customer], 
        :plan         =>params[:plan], 
        :trial_end    =>params[:trial_end], 
        :tax_percent  =>params[:tax_percent]
    }
   end

#   def customer_attributes
#     {
#     #    @params
#     #   email: @params[:email],
#     #   source: @params[:card], 
#     #   shipping: @params[:shipping],
#     #   description:@params[:description]
#     }
#   end

end
