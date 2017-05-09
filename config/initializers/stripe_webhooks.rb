require 'json'
require 'http'
#require 'mailgun'


 
#  StripeEvent.configure do |events|
#   events.subscribe 'invoice.created',                  RecordInvoiceCreated.new 
#   events.subscribe 'charge.failed',                    RecordChargesFailed.new
#   events.subscribe 'charge.succeeded',                 RecordChargesSucceeded.new
#   events.subscribe 'invoice.payment_failed',           RecordInvoiceFailed.new
#   events.subscribe 'invoice.payment_succeeded',        RecordInvoiceSucceeded.new
# end

 StripeEvent.configure do |events|
  events.subscribe 'invoice.created'           do |event|          RecordPaymentInfo.invoice_created(event) end
  events.subscribe 'charge.failed'             do |event|          RecordPaymentInfo.charge_failed(event) end
  events.subscribe 'charge.succeeded'          do |event|          RecordPaymentInfo.charge_succeeded(event) end
  events.subscribe 'invoice.payment_failed'    do |event|          RecordPaymentInfo.invoice_payment_failed(event) end
  events.subscribe 'invoice.payment_succeeded' do |event|          RecordPaymentInfo.invoice_payment_succeeded(event) end
end