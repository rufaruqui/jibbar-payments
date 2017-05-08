class RabbitPublisher
  def self.publish(queue_name, message)
  	conn = Bunny.new(CONN_SETTINGS)
    conn.start

    channel   = conn.create_channel
    queue  = channel.queue(queue_name)
    queue.publish(message.to_json)
    conn.stop
  end
 
end