Rails.application.routes.draw do
 scope module: :api, defaults: {format: :json} do
    %w(v1).each do |version|
      namespace version.to_sym do

         #actions - to manage coupons
          get  'ListAllCoupons'             => 'coupons#index'
          post 'GetCoupon'                  => 'coupons#show'
          post 'CreateCoupon'               => 'coupons#create_coupon'
          post 'UpdateCoupon'               => 'coupons#update_coupon'
          post 'DeleteCoupon'               => 'coupons#delete_coupon'

        #actions - to manage Discounts
         post 'DeleteCustomerDiscount'      => 'discounts#delete_customer_discount'
         post 'DeleteSubscriptionDiscount'  => 'discounts#delete_subscription_discount'

         #actions - to manage customers
         # get  'ListAllCustomers'           => 'customers#index'
          post 'GetCustomer'                => 'customers#show'
          post 'CreateCustomer'             => 'customers#create_customer'
          post 'UpdateCustomer'             => 'customers#update_customer'
          post 'DeleteCustomer'             => 'customers#delete_customer'
          post 'GetCustomerDetails'         =>'customers#get_customer_details'
          post 'AddNewCardToCustomer'       =>'customers#add_new_card'
          post 'RemoveCardFromCustomer'     =>'customers#delete_existing_card'
          

         #actions - to manage subscriptions
          get  'ListAllSubscriptions'       => 'subscriptions#index'
          post 'GetSubscription'            => 'subscriptions#show'
          post 'CreateSubscription'         => 'subscriptions#create_subscription'
          post 'UpdateSubscription'         => 'subscriptions#update_subscription'
          post 'CancelSubscription'         => 'subscriptions#cancel_subscription' 
          post 'ListAllSubscriptionsByPlan' => 'subscriptions#list_subscriptions_by_plan'
          post 'CancelJibbarSubscription'   => 'subscriptions#cancel_jibbar_subscription'
          post 'PauseJibbarSubscription'    => 'subscriptions#pause_jibbar_subscription'
          post 'ResumeJibbarSubscription'   => 'subscriptions#resume_jibbar_subscription'
          post 'SubscribeTestPlan'          => 'subscriptions#subscribe_test_plan'
          
          
         #actions - to manage card
         # post 'ListAllCards'               => 'cards#index'
         # post 'GetCard'                    => 'cards#show'
         # post 'CreateCard'                 => 'cards#create_card'
          post 'UpdateCard'                 => 'cards#update_card'
          post 'DeleteCard'                 => 'cards#delete_card'

         
         #actions - to manage charge
         # get  'ListAllCharges'              => 'charges#index'
          post 'GetCharge'                   => 'charges#show'
          post 'CreateCharge'                => 'charges#create_charge'
         # post 'UpdateCharge'                => 'charges#update_charge'
         # post 'CaptureCharge'               => 'charges#capture_charge'
          post 'ListAllChargesByCustomer'    => 'charges#succeeded_charge_list'
          post 'GetChargeReceipt'            =>  'charges#get_receipt'


        
        #actions - to manage invoices
          post 'ListAllInvoices'                => 'invoices#index'
          post 'GetInvoice'                     => 'invoices#show' 
       
      end
    end
  end
	mount StripeEvent::Engine, at: '/stripe-event'
end
