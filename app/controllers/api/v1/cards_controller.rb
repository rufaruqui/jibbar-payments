class Api::V1::CardsController < Api::V1::BaseController
	# before_action :requires_authentication_token
    


    #List all cards
    #You can see a list of the cards belonging to a customer or recipient. Note that the 10 most recent sources are always available on the customer object. If you need more than those 10, you can use this API method and the limit and starting_after parameters to page through additional cards.
    def index
		    @success = false;
		    @errors = nil;

		    begin 
		        @stripe_cards = Stripe::Customer.retrieve(params[:customer]).sources.all(:object => "card")
		        @cards = @stripe_cards
		        @success = true if @stripe_cards

		       rescue Stripe::StripeError => e
				  # Display a very generic error to the user, and maybe send
				  # yourself an email
		         body = e.json_body
				 @errors  = body[:error]
		       rescue => e
				  # Something else happened, completely unrelated to Stripe
				  @errors = {:message => e.message }
			end  

			  render :index
		end 


	#Retrieve a card
	#You can always see the 10 most recent cards directly on a customer or recipient; this method lets you retrieve details about a specific card stored on the customer or recipient.
		def show
		    @success = false;
		    @errors = nil;

		    begin 
		       customer     = Stripe::Customer.retrieve(params[:customer])
		       @stripe_card = customer.sources.retrieve(params[:source])
		        
		       @card = @stripe_card
		       @success = true if @stripe_card

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


	#Create a card
	#When you create a new credit card, you must specify a customer or recipient to create it on.
		def create_card
		    @success = false;
		    @errors = nil;

		    begin 
		       customer     = Stripe::Customer.retrieve(params[:customer])
		       @stripe_card = customer.sources.create(:source =>params[:source])
		        
		       @card = @stripe_card
		       @success = true if @stripe_card

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

	#Update a card
	 def update_card 

	 	     
		    @success = false;
		    @errors = nil;

		    begin 
		       customer     = Stripe::Customer.retrieve(params[:customer])
		       @stripe_card = customer.sources.retrieve(params[:source])

		       @stripe_card.address_city 	= params[:address_city] 		if params[:address_city]
		       @stripe_card.address_country = params[:address_country] 		if params[:address_country]
		       @stripe_card.address_line1 	= params[:address_line1] 		if params[:address_line1]
		       @stripe_card.address_line2 	= params[:address_line2] 		if params[:address_line2]
		       @stripe_card.address_state 	= params[:address_state] 		if params[:address_state]
		       @stripe_card.address_zip     = params[:address_zip] 			if params[:address_zip]
		       @stripe_card.exp_month     	= params[:exp_month] 			if params[:exp_month]
		       @stripe_card.exp_year     	= params[:exp_year] 			if params[:exp_year]
		       @stripe_card.name     		= params[:name] 				if params[:name]
		       @stripe_card.metadata		= params[:metadata].to_unsafe_h if params[:metadata]

		       
		        
		       @card = @stripe_card
		       @success = true if @stripe_card

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


	#Delete a card
	#You can delete cards from a customer or recipient.
		def delete_card
		    @success = false;
		    @errors = nil;

		    begin 
		       customer     = Stripe::Customer.retrieve(params[:customer])
		       @stripe_card = customer.sources.retrieve(params[:source]).delete
		        
		       @card = @stripe_card
		       @success = true if @stripe_card

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

end
