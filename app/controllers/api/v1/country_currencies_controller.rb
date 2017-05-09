class Api::V1::CountryCurrenciesController < Api::V1::BaseController
   def index
     @countries = CountryCurrency.all
     render :index
   end
 
   private
 
    def country_currency_params
      params.require(:country).permit(:name, :currency) 
    end 
end
