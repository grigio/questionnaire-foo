
class CounterHash
  attr_reader :chash
  attr_reader :count  

  def initialize
    @chash = {}
    @count = 0
  end

  def add_hash(hash_piece)
    hash_piece.map{|k,v| add(k,v)}
    @count+=1
  end

  def add(key, value)
    default_hash = { value => {:count => 1}}
    if chash[key] && chash[key][value]
      chash[key][value][:count]+= 1
    elsif chash[key]
      chash[key].merge!(default_hash)
    else
      chash[key] = default_hash
    end
  end

  def to_hash
    chash
  end
  
end