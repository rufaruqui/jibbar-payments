# == Schema Information
#
# Table name: emails
#
#  id             :integer          not null, primary key
#  template_id    :string
#  user           :string
#  subject        :string
#  body           :text
#  state          :integer          default("0")
#  public_id      :string
#  from_name      :string
#  from_address   :string
#  reply_address  :string
#  scheduled_on   :datetime
#  sent_on        :datetime
#  recipients     :jsonb            default("[]"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  template_count :integer          default("0")
#  links          :jsonb
#

class Email < ApplicationRecord
	enum state: {draft: 0, sent: 1, scheduled: 2}

	validates :template_id, :subject, :user, :from_name, :from_address, :reply_address, :presence => true
	validates :public_id, :uniqueness => true

	before_create :set_public_id

	# serialize :recipients, HashSerializer
 #    serialize :unsent, HashSerializer
 #    serialize :bounced, HashSerializer
 #    serialize :unsubscribed, HashSerializer
 #    serialize :blocked, HashSerializer
     #after_commit :refresh_template_count, on: [:create, :update, :destroy]
 	 

	def get_recipient_by_id(id)
	    self.recipients.each do |item|
	      return item if item["publicID"]==id
	    end
	end

	def set_recipient_response(recipient,action)
		r = JSON.parse(recipient)
		
		if action == 'abused'
			report = ReportAbuse.new
			report.email_id = self.public_id
			report.recipient_id = r["public_id"]
			report.reason = r["reason"]
			report.save
		end
		    
			self.recipients.each do |e|
				ec = action=='bounced' ? e["emailAddress"] : e["publicID"]
				rc = r["public_id"]
				if ec == rc
					if action=='unsubscribe'
						e["isUnsubscribed"] = true
						e["reason_for_unsubscribe"] = r["reason"]
					elsif action=='block'
						e["isBlocked"] = true
						e["reason_for_block"] = r["reason"]
					elsif action=='abused'
						e["isAbusedReport"] = true
						e["reason_for_report"] = r["reason"]
					elsif action=='bounced'
						
						e["isBounced"] = true
						e["reason_for_bounce"] = r["reason"]
					else
						# do nothing
					end
				end
						
			end
	   
		
	end
	def refresh_template_count
		#puts "#{self.user}    #{self.template_id}"
		Email.where({user: self.user, template_id: self.template_id, state: 1}).update_all(template_count: Email.where({user: self.user, template_id: self.template_id, state: 1}).count)
      # self.template_count = Email.where("user=? and template_id=? and state=?",self.user,self.template_id,1).count
      # self.save	
    end

    def self.template_count_for_user_with_last_sent_date(user_id)
     select('DISTINCT ON (template_id) template_id, template_count, sent_on').where({user: user_id, template_id: 1..Float::INFINITY, state: 1}).order("template_id, sent_on DESC")
    end


	private
    def set_public_id
      self.public_id = SecureRandom.urlsafe_base64(16)
    end
    
end
