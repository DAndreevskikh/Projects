vowels = ['a', 'e', 'i', 'o', 'u']
vowels_hash = {}

vowels.each_with_index do |letter, index|
	vowels_hash[letter] = index + 1
end

puts vowels_hash

