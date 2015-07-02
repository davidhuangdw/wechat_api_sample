require './config/initializer'
require './config/sequel'
def msg_count(min_id, max_id)
  # Message.where{message_id.to_i>=min_id && message_id.to_i<=max_id}.count
  limit = 1000_000
  all = Message.reverse_order(:message_id).limit(limit)
            .map{|m| m.message_id.to_i}
  all.select{|v| v=v.to_i; min_id<=v && v<=max_id}.size
end
