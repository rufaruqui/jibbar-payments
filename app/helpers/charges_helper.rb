module ChargesHelper
   def format_amount(amount)
        sprintf('%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end

 def format_amount1(amount)
        sprintf('%0.2f', amount.to_f ).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
   end
    def format_stripe_timestamp(timestamp)
        Time.at(timestamp).strftime("%m/%d/%Y")
    end
end
