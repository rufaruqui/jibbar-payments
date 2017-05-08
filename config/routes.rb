Rails.application.routes.draw do
  	  scope module: 'api' do
	    namespace :v1 do
	      #resources :users
	      post 'SaveEmail'                   => 'emails#save_email'
	      post 'UpdateEmail'                 => 'emails#update_email'
	      post 'GetEmail'                    => 'emails#get_email'
	      post 'GetEmailWithAnalytics'		 => 'emails#get_email_with_analytics'
	      post 'DeleteEmail'                 => 'emails#delete_email'
	      post 'CloneEmail'                  => 'emails#clone_email'
	      post 'UpdateEmailState'            => 'emails#update_email_state'
	      post 'GetAllEmails'                => 'emails#get_all_emails'
	      post 'GetAllEmailsForAnalyticsSummary' => 'emails#get_all_emails_for_analytics_summary'
	      post 'GetAllEmailsByTemplate'      => 'emails#get_all_emails_by_template'
	      post 'Send'                        => 'emails#send_mail'
	      post 'Reschedule'                  => 'emails#reschedule'
	      post 'GetRecipient'                => 'emails#get_recipient'
	      post 'RecipientResponse'           => 'emails#recipient_response'
	      post 'GetEmailForContact'          => 'emails#get_email_for_contact'
	      post 'GetAllUsedTemplatesByUser'   => 'emails#get_all_used_templates_by_user'
	      post 'GetBroadcasts'               => 'emails#get_user_broadcasts'
	  end
	end
end
