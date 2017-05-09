require 'sendgrid-ruby'
require 'base64'

class Mailler
    include SendGrid
        attr_accessor :event

        def initialize(event, customer)
          @event           = event;
          @customer_id     = customer;
        end


       def send_email(_from, _to, _subject, _content)
                from = Email.new(email: _from)
                subject = _subject
                to = Email.new(email:_to)
                content = Content.new(type: 'text/plain', value: _content)
                mail = Mail.new(from, subject, to, content)
              
               # pdf = WickedPdf.new.pdf_from_string(body)
               # invoice_in_base64 = Base64.encode64(pdf);
                attachment2 = Attachment.new
                attachment2.content = InvoiceAsPdfMailer.new.invoice_to_pdf(@customer.description, credit_purchase_email(@event), 'Payment Confirmation: Your Jibbar email receipt')
                attachment2.type = 'application/pdf'
                attachment2.filename = 'jibbar_invoice.pdf'
                attachment2.disposition = 'attachment'
                attachment2.content_id = 'Jibbar Invoice'
                mail.attachments = attachment2
                
                puts JSON.pretty_generate(mail.to_json)
                puts mail.to_json

                sg = SendGrid::API.new(api_key:  Rails.configuration.sendgrid[:secret_key], host: 'https://api.sendgrid.com')
                response = sg.client.mail._('send').post(request_body: mail.to_json)
                puts response.status_code
                puts response.body
                puts response.headers
        end   
        
        def publish_email(recipient_address,recipient_name, subject, message, heading, type, attachment)
       
           RabbitPublisher.publish("send_transactional_mail", {recipient_address: recipient_address,recipient_name: recipient_name, subject: subject, message: message, heading:heading , type: type, attachment: attachment})
        end

        def format_amount(amount)
           sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
        end  
end
