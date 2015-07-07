class ThreadPool
  def initialize(pool_size, total_size, &blk)
    queue = Queue.new
    total_size.times.map{|i| queue << i}
    @workers = pool_size.times.map do |i|
      Thread.new do
        while index=(queue.pop(true) rescue nil)
          blk.call(i, index)
        end
      end
    end
  end
  def run
    @workers.map(&:join)
  end
end