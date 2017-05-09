json.Charge do
     json.id            @charge.id
     json.date          format_stripe_timestamp(@charge.created)
     json.description   @charge.description
     json.currency      @charge.currency
     json.amount        format_amount(@charge.amount) 
     json.subtotal      format_amount1(@price)
     json.tax           format_amount1(@gst) 
     json.total         format_amount(@charge.amount)
     json.fee           @fee 
     json.paid          @charge.paid
     json.metadata      @charge.metadata
     json.customer do
          json.email       @customer.email
          json.description @customer.description
          json.address     @customer.shipping.address
          json.phone       @customer.shipping.phone
          json.name        @customer.shipping.name
     end   
    end      
json.success @success
json.errors  @errors
