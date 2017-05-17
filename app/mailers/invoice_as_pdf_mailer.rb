require 'sendgrid-ruby'
require 'base64'


class InvoiceAsPdfMailer < ApplicationMailer
  include SendGrid

  def test_pdf()
     @name = "Rokan Faruqui"
     @email_body = "Hi Test Email"
     @email_heading = "Payment Confirmation" 

    body = render_to_string template: "mailer/users.html.erb", layout: "invoice" 
    pdf = WickedPdf.new.pdf_from_string(body)
#     invoice_in_base64 = Base64.strict_encode64(pdf);
#    return invoice_in_base64;

    # #  puts email_in_base64
    #  again_pdf       = Base64.decode64(invoice_in_base64);

      File.open('/Users/rufaruqui/Documents/invoice.pdf', 'wb') do |file| file << pdf end
  end 

   def invoice_to_pdf(recipient_name, email_message, email_heading)
     @name = recipient_name
     @email_body = email_message
     @email_heading = email_heading 

    body = render_to_string template: "mailer/users.html.erb", layout: "mailer" 
    pdf = WickedPdf.new.pdf_from_string(body)
    invoice_in_base64 = Base64.strict_encode64(pdf);
   return invoice_in_base64;

    # #  puts email_in_base64
    #  again_pdf       = Base64.decode64(invoice_in_base64);

    #  File.open('/Users/rufaruqui/Documents/invoice.pdf', 'wb') do |file| file << again_pdf end
  end  

   def jibbar_charge_receipt_pdf(charge_id)
            @price = 0.00;
            @gst   = 0.00;
     
            @charge  = Stripe::Charge.retrieve(charge_id)
            @customer = Stripe::Customer.retrieve(@charge.customer)
            @amount = format_amount(@charge.amount)

            if @charge.application_fee.nil?
                @fee = nil
            else      
               @fee  = format_amount(@charge.application_fee)
            end
            
            if @charge 
                @price   = @charge.metadata.price if @charge.metadata.price;
                @gst     = @charge.metadata.gst if @charge.metadata.gst;
            end    
                
             

            @charge_id =            @charge.id
            @charge_date =          format_stripe_timestamp(@charge.created)
            @charge_description =   @charge.description
            @charge_currency =      @charge.currency
            @charge_amount =        format_amount(@charge.amount) 
            @charge_subtotal =      format_amount1(@price)
            @charge_tax =           format_amount1(@gst) 
            @charge_total =         format_amount(@charge.amount)
            @charge_fee =           @fee 
            @charge_paid =          @charge.paid
            @charge_metadata =      @charge.metadata 
            @charge_email =         @customer.email
            @charge_customer_name =   @customer.description
            @charge_address_line1 =       @customer.shipping.address.line1
            @charge_address_line2 =       @customer.shipping.address.line2
            @charge_address_city =       @customer.shipping.address.city
            @charge_address_state =       @customer.shipping.address.state
            @charge_address_postal_code =       @customer.shipping.address.postal_code
            @charge_address_country =       @customer.shipping.address.country
            
            @charge_phone =         @customer.shipping.phone
            @charge_name =          @customer.shipping.name
        
    body = render_to_string template: "mailer/charge.html.erb", layout: "receipt" 
    pdf = WickedPdf.new.pdf_from_string(body)
    invoice_in_base64 = Base64.strict_encode64(pdf);
    return invoice_in_base64;
  end 

      
      def jibbar_invoice_pdf(invoice_id)
            @invoice = Stripe::Invoice.retrieve(invoice_id) 
            if @invoice.lines.data[0].type == "subscription"
                @subscription = Stripe::Subscription.retrieve(id: @invoice.lines.data[0].id, expand: ['customer']) 
                @period_start = Time.at(@subscription.current_period_start).getutc.strftime("%m/%d/%Y")
                @period_end   = Time.at(@subscription.current_period_end).getutc.strftime("%m/%d/%Y")
                @description = "Subcription to the plan :" + @subscription.plan.name + ". Valid from " + @period_start + " to " + @period_end + "."+ @subscription.plan.metadata.broadcasts + " broadcasts."
                @customer         = @subscription.customer    
            end
             
            @invoice_id =             @invoice.id
            @invoice_date =           format_stripe_timestamp(@invoice.date)
            @invoice_description =    @description
            @invoice_currency =       @invoice.currency
            @invoice_amount_due =    format_amount(@invoice.amount_due)
            @invoice_subtotal =      format_amount(@invoice.subtotal)
            @invoice_tax =           format_amount(@invoice.tax) 
            @invoice_total =         format_amount(@invoice.total)
            @invoice_paid =           @invoice.paid 
            @invoice_email =          @customer.email
            @invoice_customer_name =   @customer.description
            @invoice_address_line1 =       @customer.shipping.address.line1
            @invoice_address_line2 =       @customer.shipping.address.line2
            @invoice_address_city =       @customer.shipping.address.city
            @invoice_address_state =       @customer.shipping.address.state
            @invoice_address_postal_code =       @customer.shipping.address.postal_code
            @invoice_address_country =       @customer.shipping.address.country 
            @invoice_phone =         @customer.shipping.phone
            @invoice_name =          @customer.shipping.name
        
    body = render_to_string template: "mailer/charge.html.erb", layout: "invoice" 
    pdf = WickedPdf.new.pdf_from_string(body)
   # File.open('/Users/rufaruqui/Documents/invoice.pdf', 'wb') do |file| file << pdf end
    invoice_in_base64 = Base64.strict_encode64(pdf);
    return invoice_in_base64;
  end 
   

   def format_amount(amount)
        sprintf('%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end
  
   def format_stripe_timestamp(timestamp)
        Time.at(timestamp).strftime("%m/%d/%Y")
   end
   
   def format_amount1(amount)
        sprintf('%0.2f', amount.to_f).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end
end