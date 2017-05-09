module CustomersHelper
    def format_amount(a, b)
        if b > 0
           sprintf('%0.2f', a.to_f / b.to_f).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
        else
            return 0.00
        end       
   end
end
