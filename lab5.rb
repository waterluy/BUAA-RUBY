def create_hash(keys, values)
	(0...values.size).inject(Hash.new(0)) { |result, i| result.store(keys[i], values[i]); result }
end

#puts create_hash(%w{a b c d}, ["1", "2", "3", "4"]) 
