class RabbitSubscriber

  def self.subscribe(queue_name)

  	 conn = Bunny.new(CONN_SETTINGS)
     conn.start

     channel   = conn.create_channel
    

  	queue     = channel.queue(queue_name)
    #exchange.publish(message, :routing_key => routing_key)
    queue.subscribe(:block => true, :manual_ack => false) do |delivery_info, properties, payload|
      puts "Received #{payload}, message properties are #{properties.inspect}"
      
    end
    
    conn.stop
  end
end