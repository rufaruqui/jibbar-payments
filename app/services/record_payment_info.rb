
class RecordPaymentInfo

#Stripe invoice_created event

    def self.invoice_created(event)

       p "an invoice is created"
        
        invoice                 = event.data.object;
        customer                = invoice.customer;
        account                 = Account.find_by("customer=? and stripe_subscription=?",customer,invoice.subscription)
        
        if account

          account.stripe_invoice  = invoice.id
          account.status = "attempted to pay"  
          account.save
          plan = Plan.find_by(:code=>account.plan)
           
         
          #Sending payment confirmation email
          ReceiptMailer.new(event, customer).email_order_confirmation
       end
    end    

#Stripe payment_succeeded event
     def self.invoice_payment_succeeded(event)

       p "an invoice attempts to be paid, and the payment succeeds"
        
        invoice                 = event.data.object;
        customer                = invoice.customer;
        account                 = Account.find_by("customer=? and stripe_subscription=?",customer,invoice.subscription)
        
        if account
          account.stripe_invoice  = invoice.id
          account.status          = "paid" if invoice.paid;
          account.save

          plan = invoice.lines.data[0][:plan]
          
          #Updating user subscription role
            UpdateSubscribeRole.new(account.public_id, plan.metadata.credits, plan.metadata.broadcasts, account.active_until).update
         #RabbitPublisher.publish("user_subscription_role",{userPublicId: @account.public_id,creditBalance: @plan.credits,broadcastBalance: @plan.broadcasts, expireon: @account.active_until})
          
          #Sending payment confirmation email
          ReceiptMailer.new(event, customer).email_payment_confirmation
        
       end
    end  


#Stripe payment_failed event
      def self.invoice_payment_failed(event)

       p "an invoice attempts to be paid, and the payment failed"
      
      invoice                 = event.data.object;
      customer                = invoice.customer;
      account                 = Account.find_by("customer=? and stripe_subscription=?",customer,invoice.subscription)
      
      if account
        account.stripe_invoice  = invoice.id
        account.status = "payment failed";
        account.save
     end 

     #Sending payment faillure email
      ReceiptMailer.new(event, customer).email_payment_faillure
      
    end

 #Stripe charge_failed event   
   def self.charge_failed(event)
     p " A new charge is created and is failed."
    charge = event.data.object;
    customer = charge.customer;
    account = Account.find_by("customer=? and stripe_charge=?",customer,charge.id)
    
    if account
      account.status = "charge failed";
      account.save
    end

     #Sending payment faillure email
      ReceiptMailer.new(event, customer).email_payment_faillure   
    end
 

#Stripe charge_succeeded event
 def self.charge_succeeded(event)
    p " a new charge is created and is successful."
    
    charge = event.data.object;
    customer = charge.customer;
    
 
    account = Account.find_by("customer=? and stripe_charge=?",customer,charge.id);
    
        if account
           account.status = "paid" if charge.paid;
           account.save 
         #  plan = BuyCredit.find_by_id(account.plan.to_i)
           UpdateSubscribeRole.new(account.public_id, charge.metadata.credits, charge.metadata.broadcasts, account.active_until).update

          #Sending payment confirmation email
           ReceiptMailer.new(event, customer).email_credit_purchase_confirmation
        end         
    end

  end