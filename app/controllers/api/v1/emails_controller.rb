module Api::V1
  class EmailsController < ApiController
    
    # POST /v1/SaveEmail
    def save_email
        userinfo = authenticate_with_user_info
        user = userinfo["user"]
        user_name = userinfo["name"]
        user_email = userinfo["email"]
        if !user.blank?
            if params[:publicId].blank?
            @email = Email.new
            else
            @email = Email.find_or_create_by(public_id: params[:publicId])
            end
            @email.subject       = params[:subject]
            @email.body          = params[:body]
            @email.template_id   = params[:templateId]
            
            @email.user          = user
            @email.from_name     = user_name
            @email.from_address  = user_email
            @email.reply_address  = params[:reply_address].blank? ? user_email : params[:reply_address]
            
        	if @email.save
                set_return_hash(true,false,{templateId: @email.template_id,publicId: @email.public_id ,subject: @email.subject,body: @email.body})
            else
                set_return_hash(false,@email.errors,nil)
            end
        end
        render json: return_hash
    end

    # POST /v1/GetEmail
    def get_email
        user = authenticate_user
        if !user.blank?
            if params[:publicId].blank?
                #set_return_hash(false,"publicID missing",nil)
                exclude_columns = ['id','created_at','updated_at','scheduled_on','template_id','body']
                columns = Email.attribute_names - exclude_columns
                @email = Email.select(columns).where(user: user, state: "sent").last

                set_return_hash(true,nil,@email)
            else
                @email = Email.find_by(public_id: params[:publicId], user: user)
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                    set_return_hash(true,nil,{templateId: @email.template_id,publicId: @email.public_id ,subject: @email.subject,body: @email.body, state: @email.state, recipients: @email.recipients})
                end
            end
        end
        render json: return_hash
    end

    # POST /v1/GetEmailWithAnalytics
    def get_email_with_analytics
        user = authenticate_user
        if !user.blank?
            if params[:publicId].blank?
                #set_return_hash(false,"publicID missing",nil)
                exclude_columns = ['id','created_at','updated_at','scheduled_on','template_id','body']
                columns = Email.attribute_names - exclude_columns
                @email = Email.select(columns).where(user: user, state: "sent").last

                set_return_hash(true,nil,{email:@email, analytics: get_analytics(@email.public_id)})
            else
                @email = Email.find_by(public_id: params[:publicId], user: user)
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                  set_return_hash(true,nil,{email:@email, analytics: get_analytics(@email.public_id)})
                 #set_return_hash(true,nil,{email:{templateId: @email.template_id,publicId: @email.public_id ,subject: @email.subject,body: @email.body, state: @email.state, recipients: @email.recipients},analytics: get_analytics(@email.public_id)})
                end
            end
        end
        render json: return_hash
    end

    # POST /v1/DeleteEmail
    def delete_email
        user = authenticate_user
        if !user.blank?
            if params[:publicId].blank?
                set_return_hash(false,"publicID missing",nil)
            else
                @email = Email.find_by(public_id: params[:publicId], user: user)
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                @email.destroy
                set_return_hash(true,nil,{message: "Successfully deleted"})
                end
            end
        end
        render json: return_hash
    end

    # POST /v1/CloneEmail
    def clone_email
        user = authenticate_user
        if !user.blank?
            
            if params[:publicId].blank?
                set_return_hash(false,"publicID missing",nil)
               
            else
                @email = Email.find_by(public_id: params[:publicId], user: user)
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                    @clone = Email.new
                    @clone.subject       = @email.subject
                    @clone.body          = @email.body
                    @clone.template_id   = @email.template_id 
                    #@clone.public_id     = get_public_id
                    @clone.user          = @email.user  
                    @clone.from_name     = @email.from_name
                    @clone.from_address  = @email.from_address
                    @clone.reply_address = @email.reply_address
                    
                    if @clone.save
                        restore_links_at_email_body
                        set_return_hash(true,false,{templateId: @clone.template_id,publicId: @clone.public_id ,subject: @clone.subject,body: @clone.body, reply_address: @clone.reply_address})
                    else
                        set_return_hash(false,@clone.errors,nil)
                    end
                end
            end
        end
        render json: return_hash
    end

    

    # POST /v1/GetAllEmails
    def get_all_emails
        user = authenticate_user
        if !user.blank?
           @emails = Email.where(state: params[:state], user: user).order('created_at DESC')
           @emails.blank? ? set_return_hash(true,nil,{}) : set_return_hash(true,nil,@emails.map{|email|{:template_id=> email.template_id, :user=>email.user, :subject=>email.subject, :public_id=>email.public_id, :sent_on=>email.sent_on, :created_at=>email.created_at, :updated_at=>email.updated_at, :scheduled_on=>email.scheduled_on}})
       end
        render json: return_hash
    end

    # POST /v1/GetAllEmailsForAnalyticsSummary
    def get_all_emails_for_analytics_summary
        user = authenticate_user
        if !user.blank?
           exclude_columns = ['id','created_at','updated_at','scheduled_on','template_id','body']
           columns = Email.attribute_names - exclude_columns
           @emails = Email.select(columns).where(user: user, state: "sent").order('sent_on DESC').limit(5)
           @emails.blank? ? set_return_hash(true,nil,{}) : set_return_hash(true,nil,@emails.map{|email|{:subject=>email.subject, :public_id=>email.public_id, :sent_on=>email.sent_on}})
       end
        render json: return_hash
    end
   
   # POST /v1/GetAllEmailsByTemplate
    def get_all_emails_by_template
        user = authenticate_user
        if !user.blank?
           @emails = Email.where(state: "sent", user: user, template_id: params[:templateId]).order('sent_on DESC')
           @emails.blank? ? set_return_hash(true,nil,{}) : set_return_hash(true,nil,@emails.map{|email|{:template_id=> email.template_id, :user=>email.user, :subject=>email.subject, :public_id=>email.public_id, :sent_on=>email.sent_on, :created_at=>email.created_at, :updated_at=>email.updated_at, :scheduled_on=>email.scheduled_on}})
       end
        render json: return_hash
    end

    # POST /v1/GetAllUsedTemplatesByUser
    def get_all_used_templates_by_user
        user = authenticate_user
        if !user.blank?
           @templates = Email.template_count_for_user_with_last_sent_date(user)
           @templates.blank? ? set_return_hash(true,nil,[]) : set_return_hash(true,nil,@templates.map{|template|{:templatePublicId=> template.template_id, :count=>template.template_count, :lastUsed=>template.sent_on}})
       end
        render json: return_hash
    end

   # POST /v1/Send
    def send_mail
        userinfo = authenticate_with_user_info
        user = userinfo["user"]
        user_name = userinfo["name"]
        user_email = userinfo["email"]
        
        if !user.blank?
          if params[:publicId].blank?
            @email = Email.new
          else
            @email = Email.find_or_create_by(public_id: params[:publicId])
          end

             if params[:recipients].blank? || params[:recipients].length == 0
                set_return_hash(false,"add recipients",nil)
             end
             #     @email = Email.new
             @email.subject       = params[:subject]
             @email.body          = params[:body]
             @email.template_id   = params[:templateId]
             #@email.public_id     = get_public_id
             @email.user          = user
             @email.from_name     = user_name
             @email.from_address  = user_email
             @email.reply_address = params[:reply_address].blank? ? user_email : params[:reply_address]
             
             @email.recipients    = params[:recipients]
             if params[:isScheduled]
             @email.state         = "scheduled"
             @email.scheduled_on  = params[:scheduled_on]
             else
             @email.state         = "sent"
             @email.sent_on       = Time.now.utc
             end
             
             
             # Test mail: No need to save
            if !params[:isTest].blank? && params[:isTest]
                RabbitPublisher.delay.publish("send_test_mail",{recipients: @email.recipients ,subject: @email.subject,body: @email.body, from_name: @email.from_name, from_address: @email.from_address})
                set_return_hash(true,false,nil)
            else

             if @email.save
                 get_links_from_email_body
                 #puts "==========Successfully saved==========="
                 if params[:isScheduled]
                 #RabbitPublisher.publish("schedule_on",{recipients: @email.recipients ,publicID: @email.public_id ,subject: @email.subject,body: @email.body, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, scheduled_on: @email.scheduled_on})
                 RabbitPublisher.delay.publish(ENV['BUNNY_EMAIL_LOGS_QUEUE'],{log_message: "Schedule: Email Saved",recipients: @email.recipients.length ,publicID: @email.public_id ,subject: @email.subject, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, scheduled_on: @email.scheduled_on, when: @email.created_at})
                 BroadcastService.addNew(user,@email.public_id,@email.subject,params[:broadcastinfo][:totalRecipients],(params[:broadcastinfo][:totalRecipients]*params[:broadcastinfo][:creditPerRecipient]),'scheduled')
                 set_return_hash(true,false,{templateId: @email.template_id,publicID: @email.public_id ,subject: @email.subject,body: @email.body})
                
                 else
                 RabbitPublisher.delay.publish(ENV['BUNNY_SEND_NOW_QUEUE'],{recipients: @email.recipients ,publicID: @email.public_id ,subject: @email.subject,body: @email.body, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address})
                 RabbitPublisher.delay.publish(ENV['BUNNY_EMAIL_LOGS_QUEUE'],{log_message: "Send now: Email Saved",recipients: @email.recipients.length ,publicID: @email.public_id ,subject: @email.subject, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, when: @email.created_at})
                 BroadcastService.addNew(user,@email.public_id,@email.subject,params[:broadcastinfo][:totalRecipients],(params[:broadcastinfo][:totalRecipients]*params[:broadcastinfo][:creditPerRecipient]),'sent')
                 @email.refresh_template_count
                 set_return_hash(true,false,{templateId: @email.template_id,publicID: @email.public_id ,subject: @email.subject,body: @email.body})
                 end
             else
                #puts "==========Save failed==========="
                set_return_hash(false,@email.errors,nil)
             end
           end
         end
        render json: return_hash
    end

    # POST /v1/Reschedule
    def reschedule
        user = authenticate_user
        if !user.blank?
            if params[:publicId].blank?
                set_return_hash(false,"publicID missing",nil)
            else
                @email = Email.find_by(public_id: params[:publicId], user: user)
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else

                    if params[:when].blank?

                        @email.state         = "sent"
                        @email.sent_on       = Time.now.utc
                        @email.scheduled_on  = Time.now.utc
                    else
                        @email.scheduled_on  = params[:when]
                    end

                    if @email.save
                        if params[:when].blank?
                        RabbitPublisher.delay.publish(ENV['BUNNY_SEND_NOW_QUEUE'],{recipients: @email.recipients ,publicID: @email.public_id ,subject: @email.subject,body: @email.body, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address})
                        RabbitPublisher.delay.publish(ENV['BUNNY_EMAIL_LOGS_QUEUE'],{log_message: "Send now: Rescheduled",recipients: @email.recipients.length ,publicID: @email.public_id ,subject: @email.subject, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, when: Time.now.utc})
                        BroadcastService.addNew(user,@email.public_id,@email.subject,0,0,'sent')
                        @email.refresh_template_count
                        else
                        RabbitPublisher.delay.publish(ENV['BUNNY_EMAIL_LOGS_QUEUE'],{log_message: "Rescheduled",recipients: @email.recipients.length ,publicID: @email.public_id ,subject: @email.subject, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, when: Time.now.utc})
                        end
                        set_return_hash(true,nil,{templateId: @email.template_id,publicId: @email.public_id ,subject: @email.subject, state: @email.state})
                    else
                        set_return_hash(false,@email.errors,nil)
                    end
                end
            end
        end
        render json: return_hash

    end

   
   # POST /v1/GetRecipient
    def get_recipient
            
            if params[:email].blank? || params[:contact].blank?
                set_return_hash(false,"argument mismatch",nil)
               
            else
                @email = Email.find_by(public_id: params[:email])
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                    
                    recipient = @email.get_recipient_by_id(params[:contact])
                    
                    set_return_hash(true,false,{email_public_id: @email.public_id,email: recipient["emailAddress"],first_name: recipient['firstName'], last_name: recipient['lastName']})
                    
                end
            end
       
        render json: return_hash
    end

    # POST /v1/RecipientResponse
    def recipient_response
            
            if params[:email_public_id].blank? || params[:action].blank? || params[:recipient].blank?
                set_return_hash(false,"argument mismatch",nil)
               
            else
                @email = Email.find_by(public_id: params[:email_public_id])
                
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
                    @email.set_recipient_response(params[:recipient],params[:what_to_do])
                    @email.save

                    set_return_hash(true,false,nil)
                    
                end
            end
       
        render json: return_hash
    end
    
    # POST /v1/GetEmailForContact
    def get_email_for_contact
            
            if params[:email].blank? || params[:contact].blank? 
                set_return_hash(false,"argument mismatch",nil)
               
            else
                @email = Email.find_by(public_id: params[:email])
                
                if @email.blank?
                set_return_hash(false,"record not found",nil)
                else
set_return_hash(true,false,{email_public_id: @email.public_id,email_subject: @email.subject, from_name: @email.from_name, from_address: @email.from_address, reply_address: @email.reply_address, body: @email.body,contact: @email.get_recipient_by_id(params[:contact])})
                    
                end
            end
       
        render json: return_hash
    end

    # POST /v1/GetBroadcasts
    def get_user_broadcasts
        user = authenticate_user
        if !user.blank?
           @broadcasts = BroadcastService.getAll(user)
           @broadcasts.blank? ? set_return_hash(true,nil,{}) : set_return_hash(true,nil,@broadcasts)
       end
        render json: return_hash
   end
   private
   def set_return_hash(success,error,result)
      @retHash = Hash.new
      @retHash["success"] = success
      @retHash["error"]   =  error
      @retHash["result"]  =  result
   end

   def return_hash
      @retHash.to_json
   end

   def authenticate_user
       token = bearer_token
       auth = HTTP.auth("Bearer #{token}").post("https://jibbar-sso.herokuapp.com/v1/GetUser", :json => {}).body
       response = JSON.parse(auth)
       if response["user"].blank?
             set_return_hash(false,true,"unauthorized request")
        else
             response["user"]
        end
   end

   def authenticate_with_user_info
       token = bearer_token
       auth = HTTP.auth("Bearer #{token}").post("https://jibbar-sso.herokuapp.com/v1/GetUser", :json => {}).body
       response = JSON.parse(auth)
       if response["user"].blank?
             set_return_hash(false,true,"unauthorized request")
         else
             response
        end
   end
   
   def get_analytics(email_public_id)
    token = bearer_token
    request = HTTP.auth("Bearer #{token}").post("http://jibbar-analytics.herokuapp.com/v1/GetAnalyticsByEmail", :json => {publicId: email_public_id}).body
       
    response = JSON.parse(request)
    return response
   end

   def get_links_from_email_body
    body = URI.decode(@email.body)
    doc = Nokogiri::HTML(body)
    links = []
    doc.xpath('//a[@customizable]').each {|link| 
                if link["href"]!="#" && link["href"]!="" 

                links << {text: link.text.strip, url: link["href"]} 
                link["href"] = "#{get_client_app_base_url}redirect/#{@email.public_id}/__RECIPIENT__/#{ENV['APP_ENV']}/#{Base64.strict_encode64(link['href'])}"
                
                end
                }

    body = doc.to_s   
    body = body.sub "</body>","<img src='__ANALYTICS_IMAGE__'  style='width: 1px; height: 1px;'/></body>"
    body = body.sub "__UNSUBSCRIBE__","#{get_client_app_base_url}unsubscribe/__RECIPIENT__/#{@email.public_id}/#{ENV['APP_ENV']}"
    body = body.sub "__ABUSE__","#{get_client_app_base_url}abuse/__RECIPIENT__/#{@email.public_id}/#{ENV['APP_ENV']}"
    body = body.sub "__BLOCK__","#{get_client_app_base_url}block/__RECIPIENT__/#{@email.public_id}/#{ENV['APP_ENV']}"
    body = body.sub "__ANALYTICS_IMAGE__","#{get_client_app_base_url}#{@email.public_id}/#{ENV['APP_ENV']}/__RECIPIENT__.gif"
    body = body.sub "__BROWSERVIEW__","#{get_view_app_base_url}#{@email.public_id}/__RECIPIENT__/#{ENV['APP_ENV']}"
    @email.body = URI.encode(body)
    @email.links = links
    @email.save
   end

   def restore_links_at_email_body
    body = URI.decode(@clone.body)
    doc = Nokogiri::HTML(body)
    doc.xpath('//a[@customizable]').each {|link| 
                if link["href"]!="#" && link["href"]!="" 
                  encoding_options = {
                    :invalid           => :replace,  # Replace invalid byte sequences
                    :undef             => :replace,  # Replace anything not defined in ASCII
                    :replace           => '',       # Use a blank for those replacements
                    :universal_newline => true       # Always break lines with \n
                  }

                  url = link["href"].encode(Encoding.find('ASCII'), encoding_options)
                  url.sub! "#{get_client_app_base_url}redirect/",""
                  url = url.split("/__RECIPIENT__/")[1]
                  url = "#{Base64.decode64(url)}"
                  link["href"] = url
                end
                }
    body = doc.to_s
    body = body.gsub "#{@email.public_id}","#{@clone.public_id}"
    @clone.body = URI.encode(body)
    @clone.save
   end

  end
end