class Api::V1::SubscriptionsController < Api::V1::BaseController
	# before_action :requires_authentication_token 
 
  #Finding customers by plan
    def list_subscriptions_by_plan
      @success = false;
          @errors = nil;

         begin 
         @stripe_subscriptions = Stripe::Subscription.all(:plan=>params[:plan])         
         @subscriptions = @stripe_subscriptions[:data]
         @success = true if @stripe_subscriptions

         rescue Stripe::StripeError => e 
           body = e.json_body
       @errors  = body[:error]
         rescue => e 
        @errors = {:message => e.message }
      end  
       render :index
    end 




	#list of all subscriptions
	def index
	   @success = false;
       @errors = nil;
       begin 
       @stripe_subscriptions = Stripe::Subscription.list()
       @subscriptions = @stripe_subscriptions[:data]
       @success = true if @stripe_subscriptions

       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :index
	end	




	#retrieve a subscription
	def show
    	@success = false;
        @errors = nil;
        
       begin 
       @subscription = Stripe::Subscription.retrieve(params[:id])
       @success = true if @subscription;
       rescue Stripe::StripeError => e	   
         body = e.json_body
		     @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end



	#create a subscription

    def create_subscription

        @success = false;
        @errors = nil;
        
       begin 
       public_id = params[:subscription][:public_id] 
       params[:subscription].delete :public_id
       @subscription =  subscribe_plan(public_id, params[:plan], params[:customer])
       @success = true if @subscription;
       rescue Stripe::StripeError => e	   
         body = e.json_body
		     @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end


	#update a subscription
	def update_subscription
    	@success = false;
        @errors = nil;

       begin 
       @subscription = PaymentService.new(params[:subscription]).update_subscription
       @success = true if @subscription;
       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  

	  render :show
    end


    def resume_jibbar_subscription
        @success = false;
        @errors = nil;

       begin  
        @public_id        = params[:public_id];
        @account          = Account.find_by(:public_id=>@public_id, :stripe_charge=>nil) if @public_id;
     
       #     subscribe_plan(@public_id, @account.plan, @account.customer) if @account 
       if !@account.active_until.nil?
             @trial_end = :now
       else
             @trial_end =  @account.active_until.to_i; 
        end
             
      @subscription= subscribe_plan(@public_id, @account.plan, @account.customer,  @trial_end) if @account;
       
         if @subscription.present?
               @account.status    = "active";
               @customer = Stripe::Customer.retrieve(@account.customer)
               @account.save;
               @success = true;
             Mailler.new(nil,nil).publish_subscription_resumed_email({name:@customer.description,email:@customer.email })    
         end

       rescue Stripe::StripeError => e	   
         body = e.json_body
		     @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
       
        render :show
    end



    def pause_jibbar_subscription
        @success = false;
        @errors = nil;
       
       begin 
        @public_id        = params[:public_id];
        @account          = Account.find_by(:public_id=>@public_id,:stripe_charge=>nil) if @public_id; 
            @customer         = Stripe::Customer.retrieve(@account.customer)  if @account.present?;
            @subscription     = Stripe::Subscription.retrieve(@customer.subscriptions.data[0].id);
            @subscription     = @subscription.delete(at_period_end:true);
            
            if @subscription.cancel_at_period_end;
                @account.status    = "paused";
                @account.save;
                @success = true;
       Mailler.new(nil,nil).publish_subscription_paused_email({name:@customer.description,email:@customer.email }) 
            end
          

           rescue Stripe::StripeError => e 
            body = e.json_body
            @errors  = body[:error]
            rescue => e 
                @errors = {:message => e.message }
            end  

         render :show
    end


    def cancel_jibbar_subscription
        @success = false;
        @errors = nil;
       
       begin 
        @public_id        = params[:public_id];
        @account          = Account.find_by(:public_id=>@public_id, :stripe_charge=>nil) if @public_id;
 
            @customer         = Stripe::Customer.retrieve(@account.customer)  if @account.present?;
            @subscription     = Stripe::Subscription.retrieve(@customer.subscriptions.data[0].id)
            @subscription     = @subscription.delete(at_period_end:true);
            if @subscription.cancel_at_period_end
                @account.status    = "cancelled";
                @account.save
                @success = true;
         
     Mailler.new(nil,nil).publish_subscription_cancelled_email({name:@customer.description,email:@customer.email })                
            end
       
            rescue Stripe::StripeError => e 
             body = e.json_body
            @errors  = body[:error]
            rescue => e 
                @errors = {:message => e.message }
            end  
        
         render :show
    end

	#cancel a subscription or cancelling at the end of period
    def cancel_subscription
    		@success = false;
            @errors = nil;

       begin 
       	@stripe_subscription= Stripe::Subscription.retrieve(params[:id])

        if params[:at_period_end]
       	    @stripe_subscription.delete( :at_period_end => params[:at_period_end])
        else
            @stripe_subscription.delete()
        end 
            
        @success = true if @stripe_subscription
        @subscription = @stripe_subscription
       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
       rescue => e 
		  @errors = {:message => e.message }
	  end  
     render :show
    end


      def subscribe_test_plan
 	        @success = true;
            @errors = nil;
           

            begin
             @public_id = params[:public_id];

                 @account = Account.find_or_initialize_by(:public_id=>@public_id) if @public_id
                 @customer = Stripe::Customer.create(:description=>params[:name], :email=>params[:email]);
                 @stripe_subscription = Stripe::Subscription.create( :customer=>@customer.id, :plan=>"TD001");

                    @account.update_attributes(:customer           => @customer.id,
                                     :plan                => "TD001",
                                     :status              => "test_drive",
                                     :active_until        => Time.at(@stripe_subscription.current_period_end).to_datetime,
                                     :recurrent           => false,
                                     :stripe_subscription => @stripe_subscription.id,
                                     :stripe_charge       => nil
                                     )

                #  @account.stripe_subscription = @stripe_subscription.id
                #  @account.customer = @customer.id
                #  @account.save
                 @stripe_subscription.delete( :at_period_end=>true)
                 @subscription = @stripe_subscription
       rescue Stripe::StripeError => e 
         body = e.json_body
		 @errors  = body[:error]
           @success = false;
       rescue => e 
          @success = false;
		  @errors = {:message => e.message }
	  end  

     render :show 
    end

private 
    def cancel_sub(sub_id, at_period_end=true)
        begin  
                @stripe_subscription= Stripe::Subscription.retrieve(sub_id)
              if at_period_end
                     @stripe_subscription.delete( :at_period_end => true) 
              else
                     @stripe_subscription.delete()
              end

                @subscription = @stripe_subscription
            rescue Stripe::StripeError => e 
                body = e.json_body
                @errors  = body[:error]
            rescue => e 
                @errors = {:message => e.message }
        end  
    end



  def subscribe_plan(public_id, plan_id, customer_id, trial_end='now')
   
      #Retrive subscription
        @subs = Stripe::Subscription.list(:customer=>customer_id)
    
       #Delete existing subscription if any
        cancel_sub(@subs.data[0].id, false) unless !@subs.data.present? || @subs.data[0].object != "subscription" || @subs.data[0].status != "active";
       
       #Create new subscriptions
        @stripe_subscription = PaymentService.new({:plan=>plan_id, :customer=>customer_id, :trial_end=>trial_end, :tax_percent=>params[:tax_percent]}).create_subscription
   
       #Update Jibbar customer
       if @stripe_subscription     
           @account = Account.find_or_initialize_by(:public_id=>public_id)
           @account.update_attributes(:customer           => customer_id,
                                     :plan                => plan_id,
                                     :status              => "pending",
                                     :active_until        => Time.at(@stripe_subscription.current_period_end).to_datetime,
                                     :recurrent           => true,
                                     :stripe_subscription => @stripe_subscription.id,
                                     :stripe_charge       => nil
                                     )
          
       end

           @plan = Stripe::Plan.retrieve(plan_id);
           
        if @plan.present?
             cancel_sub(@stripe_subscription.id, true) unless @plan.metadata.is_auto_renewable;
          end

        return @stripe_subscription
    end  

end