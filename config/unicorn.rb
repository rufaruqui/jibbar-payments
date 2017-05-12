worker_processes ENV["RAILS_ENV"] == "development" ? 1 : Integer(ENV["WEB_CONCURRENCY"] || 3)
#worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30
preload_app true
@plan_pid = nil
before_fork do |server, worker|
  @plan_pid ||= spawn("bundle exec rake environment " + \
  "update_stripe_plan")
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # Thread.new do
  #   RabbitAmqp.delay.subscribe("tq3")
  # end

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  
end