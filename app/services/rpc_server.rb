class RpcServer

  def self.update_stripe_plan(queue_name)
    conn = Bunny.new(CONN_SETTINGS)
    conn.start

    channel   = conn.create_channel
    channel.prefetch(1)
    queue     = channel.queue(queue_name)
    exchange = channel.default_exchange
    #exchange.publish(message, :routing_key => routing_key)
    queue.subscribe(:block => true) do |delivery_info, properties, payload|
      puts "Received #{payload}, message properties are #{properties.inspect}"
      response = StripePlan.update(payload)
      exchange.publish(response, :routing_key => properties.reply_to, :correlation_id => properties.correlation_id, :content_type => 'application/json')

      
    end
    
   # conn.stop
  end
end