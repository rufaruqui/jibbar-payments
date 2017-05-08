class EmailView
	def self.return_email_view(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)
		retHash = Hash.new
	    
		email = Email.find_by(public_id: json_msg[:email])
		if email.blank?
		  retHash["success"] = false
	      retHash["error"]   =  "record not found"
	      retHash["result"]  =  nil
          
        else
          retHash["success"] = true
	      retHash["error"]   =  false
	      retHash["result"]  =  {email_public_id: email.public_id,email_subject: email.subject, from_name: email.from_name, from_address: email.from_address, reply_address: email.reply_address, body: email.body,contact: email.get_recipient_by_id(json_msg[:contact])}
          
        end
		retHash.to_json
	end
end