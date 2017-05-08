class SentMail
	def self.update(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)
		
		if json_msg.length > 0
		json_msg.each do |email_public_id, recipient|

			email = Email.find_by(public_id: email_public_id)
				recipient.each do |r|
					
					contact = {public_id: r[:recipient], reason: r[:reason]}
			        email.set_recipient_response(contact.to_json,'bounced')
			    end
			email.save
		  end
	    end
	end

    def self.recipient_response(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)
		@email = Email.find_by(public_id: json_msg[:email_public_id])
		if !@email.blank?
			@email.set_recipient_response(json_msg[:recipient],json_msg[:what_to_do])
			@email.save
		end
	end

end