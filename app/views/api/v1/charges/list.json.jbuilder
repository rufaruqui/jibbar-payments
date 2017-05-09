json.Charges @charges do |charge|
        json.id       charge.id
        json.amount            format_amount(charge.amount)
        if charge.application_fee.nil? 
            json.applicaton_fee         charge.application_fee
        else
             json.applicaton_fee        format_amount(charge.applicaton_fee)
        end
        json.fee               
        json.currency               charge.currency
        json.customer               charge.customer
        json.invoice                charge.invoice
        json.description            charge.description
        json.date                   charge.created
        json.paid                   charge.paid
     end
json.success @success
json.errors  @errors
