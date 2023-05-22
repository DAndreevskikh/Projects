puts "What is your name?"

name = gets.chomp

puts "What is your height?"

height = gets.chomp.to_i


ideal_weight = (height - 110) * 1.15

if ideal_weight < 0
	puts "You have an ideal weight"
else
puts "Your ideal weight, #{name}, is #{ideal_weight} kg" 
end	
       