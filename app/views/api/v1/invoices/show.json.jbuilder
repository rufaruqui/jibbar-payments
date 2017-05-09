json.Invoice do
     json.id            @invoice.id
     json.date          format_stripe_timestamp(@invoice.date)
     json.description   @description
     json.currency      @invoice.currency
     json.amount        format_amount(@invoice.amount_due)
     json.subtotal      format_amount(@invoice.subtotal)
     json.tax_percent   format_amount(@invoice.tax_percent)
     json.tax           format_amount(@invoice.tax)
     json.total         format_amount(@invoice.total)
     json.paid          @invoice.paid
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
