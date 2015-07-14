# http://mp.weixin.qq.com/wiki/17/fa4e1434e57290788bde25603fa2fcbd.html

class WechatApi
  def self.error_meaning
    return @error_meaning if @error_meaning
    @error_meaning = {}
    path = File.expand_path('../error_code.txt', __FILE__)
    File.open(path).each do |f|
      f.each_line do |line|
        words = line.strip.split(/\s+/)
        if words.size >= 2
          code, *meaning = words
          meaning = meaning.join(' ')
          @error_meaning[code.to_i] = meaning
        end
      end
    end
    @error_meaning
  end

  def error_meaning(code)
    self.class.error_meaning[code.to_i]
  end
end
