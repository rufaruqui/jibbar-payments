require 'sendgrid-ruby'
require 'base64'

class Mailler
    include SendGrid
        attr_accessor :event

        def initialize(event, customer)
          @event           = event;
          @customer_id     = customer;
        end

        def publish_email(recipient_address,recipient_name, subject, message, heading, type, attachment)     
           RabbitPublisher.publish(ENV['BUNNY_SEND_TRANSACTIONAL_MAIL_QUEUE'], {recipient_address: recipient_address,recipient_name: recipient_name, subject: subject, message: message, heading:heading , type: type, attachment: attachment})
        end
       
        def publish_subscription_paused_email(customer) 
          RabbitPublisher.publish(ENV['BUNNY_SEND_TRANSACTIONAL_MAIL_QUEUE'], {recipient_address: customer[:email],recipient_name:customer[:name], subject: 'not required', message: 'not required',heading: 'not required', type: 'subscription_paused'})
        end

        def publish_subscription_resumed_email(customer) 
          RabbitPublisher.publish(ENV['BUNNY_SEND_TRANSACTIONAL_MAIL_QUEUE'], {recipient_address: customer[:email],recipient_name:customer[:name], subject: 'not required', message: 'not required',heading: 'not required', type: 'subscription_reactivated'})
        end

        def publish_subscription_cancelled_email(customer) 
          RabbitPublisher.publish(ENV['BUNNY_SEND_TRANSACTIONAL_MAIL_QUEUE'], {recipient_address: customer[:email],recipient_name:customer[:name], subject: 'not required', message: 'not required',heading: 'not required', type: 'subscription_cancelled'})
        end


        def format_amount(amount)
           sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
        end  
end
