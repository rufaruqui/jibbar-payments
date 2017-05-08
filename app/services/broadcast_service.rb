class BroadcastService
	def self.addNew(user_id,email_id,email_subject,number_of_recipients,credits_consumed,status)
		   broadcast = Broadcast.find_by(user_id: user_id, email_id: email_id)
		   if broadcast.blank?
             broadcast = Broadcast.new
             broadcast.user_id   = user_id
             broadcast.email_id  = email_id
             broadcast.emails_subject  = email_subject
             broadcast.number_of_recipient  = number_of_recipients
             broadcast.total_credit_consumed  = credits_consumed
             broadcast.meta_data = status
             RabbitPublisher.publish(ENV['BUNNY_USER_SUBSCRIPTION_ROLE_QUEUE'],{userPublicId: user_id,creditBalance: (0-credits_consumed),broadcastBalance: -1, expireon: nil})
           else
           	 broadcast.meta_data = status
           end
           
           broadcast.save
	end

	def self.getAll(user_id)
		Broadcast.where('user_id=?',user_id).order('created_at DESC')
    end

end
