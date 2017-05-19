class ReceiptMailer < Mailler
      

       def email_credit_purchase_confirmation 
            @customer = Stripe::Customer.retrieve(@event.data.object.customer)
            @invoice_in_pdf = InvoiceAsPdfMailer.new.jibbar_charge_receipt_pdf(@event.data.object.id) #InvoiceAsPdfMailer.new.invoice_to_pdf(@customer.description, credit_purchase_email(@event), 'Payment Confirmation: Your Jibbar email receipt')
            publish_email(@customer.email,@customer.description, 'Payment Confirmation: Your Jibbar email receipt', credit_purchase_email(@event), 'Payment Confirmation', 'payment_confirmation', @invoice_in_pdf)       
       end 

       def email_payment_faillure
            @customer = Stripe::Customer.retrieve(@event.data.object.customer)
          #  send_email('jibbarapp@gmail.com',  @customer.email, 'Payment Unsuccesfull: Your Jibbar purchase', payment_faillure_email(@event) )
            publish_email(@customer.email,@customer.description, 'Payment Faillure: Your Jibbar email receipt', payment_faillure_email(@event), 'Payment Faillure', 'payment_confirmation', nil)       

       end 

       def email_order_confirmation
                    #Sending email receipt
                @subscription = Stripe::Subscription.retrieve(id: @event.data.object.subscription, expand: ['customer'])

                # Format the period start and end dates
                @period_start = Time.at(@subscription.current_period_start).getutc.strftime("%m/%d/%Y")
                @period_end = Time.at(@subscription.current_period_end).getutc.strftime("%m/%d/%Y")

                # send_email('jibbarapp@gmail.com',  @subscription.customer.email, 'Order Confirmation: Your Jibbar email receipt', plan_order_email(@event) )
            publish_email( @subscription.customer.email,@subscription.customer.description, 'Order Confirmation: Your Jibbar email receipt', plan_order_email(@event), 'Order Confirmation', 'order_confirmation', nil)       
  
        end
            
        def email_payment_confirmation
                #Sending email receipt
                @subscription = Stripe::Subscription.retrieve(id: @event.data.object.subscription, expand: ['customer'])

                # Format the period start and end dates
                @period_start = Time.at(@subscription.current_period_start).getutc.strftime("%m/%d/%Y")
                @period_end = Time.at(@subscription.current_period_end).getutc.strftime("%m/%d/%Y")
            @invoice_in_pdf = InvoiceAsPdfMailer.new.jibbar_invoice_pdf(@event.data.object.id)
            publish_email( @subscription.customer.email,@subscription.customer.description, 'Payment Confirmation: Your Jibbar email receipt', plan_payment_email(@event), 'Payment Confirmation', 'payment_confirmation', @invoice_in_pdf)       
  
        end


        def credit_purchase_email (event)
                  <<-EOF
                  We received the payment for your jibbar.com purchase. Thank you for being a customer!

                  Questions? Please contact support@jibbar.com. 

                  Jibbar RECEIPT -   #{@event.data.object.description}

                  Total: #{format_amount(@event.data.object.amount)} #{@event.data.object.currency}

                  Charged to: #{@customer.sources.first.brand} ending in #{@customer.sources.first.last4}
                  Date: #{Time.now.strftime("%m/%d/%Y")}  

                  EOF
        end

          


        def payment_faillure_email (event)
                  <<-EOF 

                  Your payment at Jibbar.com purchase is unsuccesfull.   
 
                  Jibbar purchase  for #{@customer.description}

                  Falliure Message : #{@event.data.object.failure_message} 
                  
                  Attempted to charge your carde : #{@customer.sources.first.brand} ending in #{@customer.sources.first.last4}
                  Date: #{Time.now.strftime("%m/%d/%Y")} 
 

                  EOF
        end

         def plan_payment_email(event)
                  <<-EOF

                  We received the payment for your jibbar.com subscription. Thank you for being a customer!

                  Questions? Please contact support@jibbar.com.
 
                  Jibbar RECEIPT -  for the subscription of #{@subscription.plan.name} plan

                  Total: #{format_amount(@event.data.object.amount_due)} #{@subscription.plan.currency}

                  Charged to: #{@subscription.customer.sources.first.brand} ending in #{@subscription.customer.sources.first.last4}
                  Invoice ID: #{@event.data.object.id}
                  Date: #{Time.now.strftime("%m/%d/%Y")}
                  For service through: #{@period_start} and #{@period_end}
 

                  EOF
        end

         def plan_order_email(event)
                  <<-EOF 

                  We received an order for your jibbar.com subscription. Thank you for being a customer!

                  Questions? Please contact support@jibbar.com. 

                  Jibbar RECEIPT - for the subscription of #{@subscription.plan.name} plan

                  Total: #{format_amount(@event.data.object.amount_due)} #{@subscription.plan.currency}

                  Will charge your card #{@subscription.customer.sources.first.brand} ending in #{@subscription.customer.sources.first.last4}
                  Date: #{Time.now.strftime("%m/%d/%Y")}
                  For service through: #{@period_start} and #{@period_end} 

                  EOF
        end

        def jibbar_credit_puchase_email_body (event)
          <<-EOF 
            Your tax invoice and receipt is attached

            We have processed your Jibbar order. You were charged a total of  Total: #{format_amount(@event.data.object.amount)} #{@event.data.object.currency}

            Date #{Time.now.strftime("%m/%d/%Y")} 
            #{@customer.shipping.name}
            #{@customer.shipping.address.line1}  #{@customer.shipping.address.line1}
            #{@customer.shipping.address.city}  #{@customer.shipping.address.postal_code}
            #{@customer.shipping.address.state}  #{@customer.shipping.address.country}
          
            Order details

            Description					                 Amount 
            ----------------------------------------------------------------------------
             #{@event.data.object.description}        #{@event.data.object.metadata.price}
             


            Sub total			 #{@event.data.object.metadata.price}
            GST (10%)			 #{@event.data.object.metadata.gst}
            Amount due		 #{format_amount(@event.data.object.amount)}


            In the Billing History section of your Jibbar account you can find a detailed history of your billing activity and invoice/receipt copies.

            Thank you for choosing to use Jibbar.


            Remember that you can receive free email credits with our Refer a Friend program.
          
         EOF

        end


end
