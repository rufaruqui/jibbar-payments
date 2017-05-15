class RpcClient
  
  attr_reader :reply_queue
  attr_accessor :response, :call_id
  attr_reader :lock, :condition
  
  def initialize(request_queue)
    @conn = Bunny.new(CONN_SETTINGS)
    @conn.start
    @channel   = @conn.create_channel
    @exchange  = @channel.default_exchange
    @server_queue   = request_queue
    @reply_queue    = @channel.queue(response_queue, :exclusive => true)
    @lock      = Mutex.new
    @condition = ConditionVariable.new
    that       = self
    @reply_queue.subscribe do |delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload
        that.lock.synchronize{that.condition.signal}
      end
    end

  end

  def call(msg)
    self.call_id = self.generate_uuid
    @exchange.publish(msg.to_json,
      :routing_key    => @server_queue,
      :correlation_id => call_id,
      :reply_to       => @reply_queue.name)

    lock.synchronize{condition.wait(lock)}
    @channel.close
    @conn.close
    response
  end
  
  protected

  def generate_uuid
    # very naive but good enough for code
    # examples
    "#{rand}#{rand}#{rand}"
  end
 
end
