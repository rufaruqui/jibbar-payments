class StripePlan
	def self.update(msg)
		json_msg = JSON.parse(msg, symbolize_names: true)
		retHash = Hash.new
	    # return values start
	    retHash["success"] = true
	    retHash["error"]   =  ""
	    retHash["result"]  =  nil
	    # return values end
		# email = Email.find_by(public_id: json_msg[:email])
		# if email.blank?
		#   retHash["success"] = false
	 #      retHash["error"]   =  "record not found"
	 #      retHash["result"]  =  nil
          
  #       else
  #         recipient = email.get_recipient_by_id(json_msg[:contact])
  #         retHash["success"] = true
	 #      retHash["error"]   =  false
	 #      retHash["result"]  =  {email_public_id: email.public_id,email: recipient["emailAddress"],first_name: recipient['firstName'], last_name: recipient['lastName']}
          
  #       end


        # finally return this
		retHash.to_json
	end
end