desc "This task is called by the Heroku scheduler add-on"

task :send_scheduled_emails => :environment do
  #User.send_reminders
  emails = Email.where("state = ? and scheduled_on < ?",2, 1.hour.from_now)
  emails.each do |email|
  	email.update_columns(sent_on: Time.now.utc, state: "sent", scheduled_on: nil)
  	RabbitPublisher.delay.publish(ENV['BUNNY_SEND_NOW_QUEUE'],{recipients: email.recipients ,publicID: email.public_id ,subject: email.subject,body: email.body, from_name: email.from_name, from_address: email.from_address, reply_address: email.reply_address})
    RabbitPublisher.delay.publish(ENV['BUNNY_EMAIL_LOGS_QUEUE'],{log_message: "Send now: Scheduled mail",recipients: email.recipients.length ,publicID: email.public_id ,subject: email.subject, from_name: email.from_name, from_address: email.from_address, reply_address: email.reply_address, when: email.created_at})
    BroadcastService.addNew(email.user,email.public_id,email.subject,0,0,'sent')
                 
    email.refresh_template_count
  end
                 
  puts "sending scheduled emails"
end

task :bounced_update => :environment do
  RabbitSubscriber.subscribe(ENV['BUNNY_BOUNCED_EMAILS_QUEUE'])
  puts "listening bounced_emails queue"
end

task :return_email_view => :environment do
  RpcServer.return_email_view(ENV['BUNNY_EMAIL_VIEW_QUEUE'])
  puts "rpc_server listening ..."
end
task :return_email_recipient => :environment do
  RpcServer.return_email_recipient(ENV['BUNNY_EMAIL_RECIPIENT_QUEUE'])
  puts "rpc_server listening ..."
end

task :email_recipient_response => :environment do
  RabbitSubscriber.subscribe(ENV['BUNNY_RECIPIENT_RESPONSE_QUEUE'])
  puts "listening recipient response queue"
end