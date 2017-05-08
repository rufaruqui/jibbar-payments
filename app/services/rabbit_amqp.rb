class RabbitAmqp
  def self.publish(queue_name, message)
  	conn = Bunny.new(CONN_SETTINGS)
    conn.start

    channel   = conn.create_channel
    queue     = channel.queue(queue_name)
    queue.publish(message.to_json)
    conn.stop
  end
  def self.subscribe(queue_name)

    begin
      
      rabbitmq_connection = Bunny.new(CONN_SETTINGS)
      rabbitmq_connection.start
    rescue Bunny::TCPConnectionFailed => e
      puts "Connection failed"
    end
    begin
      rabbitmq_channel = rabbitmq_connection.create_channel
      queue    = rabbitmq_channel.queue(queue_name)
      queue.subscribe(:block => true, :manual_ack => false) do |delivery_info, properties, payload|
        puts "Received #{payload}, message properties are #{properties.inspect}"
      end
    rescue Bunny::PreconditionFailed => e
      puts "Channel-level exception! Code: #{e.channel_close.reply_code},
      message: #{e.channel_close.reply_text}".squish
    ensure
      rabbitmq_connection.create_channel.queue_delete(queue)
    end

    
    #conn.stop
  end
end