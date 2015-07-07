class Util
  class << self
    def logfile(time, period = 12.hour)
      round = time.to_i/period*period
      if @last_round != round
        @last_round = round
        @log_file.close if @log_file

        fname = 'tmp/' + 'perf_' + Time.at(round).strftime('%m-%d-%I') + "-#{round}.log"
        @log_file = File.new(fname, 'a')
      end
      @log_file
    end

    def last_word(str)
      str.split(/[\s()]+/).reject(&:blank?).last
    end

    def warmup(srm_conn, warmup_count=2)
      warmup_count.times do |i|
        srm_conn.run do
          result = push_msg
          report = report_str(result)
          puts report
          puts "warming up remain: #{warmup_count-1-i}."
        end
      end
    end
  end
end