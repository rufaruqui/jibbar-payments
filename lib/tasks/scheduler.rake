desc "This task is called by the Heroku scheduler add-on"

task :update_stripe_plan => :environment do
  RpcServer.update_stripe_plan(ENV['BUNNY_STRIPE_PLAN_QUEUE'])
  puts "rpc_server listening ..."
end