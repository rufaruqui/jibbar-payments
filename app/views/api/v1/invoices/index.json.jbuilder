json.Invoices @invoices do |invoice|
     json.id            invoice.id
     json.date          format_stripe_timestamp(invoice.date)
     json.description   invoice.description
     json.currency      invoice.currency
     json.amount        format_amount(invoice.amount_due)
     json.subtotal      format_amount(invoice.subtotal)
     json.tax_percent   invoice.tax_percent
     json.tax           invoice.tax
     json.total         format_amount(invoice.total)
     json.paid          invoice.paid
    end 
json.success @success
json.errors  @errors

 