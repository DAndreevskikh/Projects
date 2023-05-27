basket = {}

loop do 
	puts "Enter the name of the product('stop' to complete)"
name = gets.chomp


break if name.downcase == 'stop'


puts "Enter price per item: "
price = gets.chomp.to_f


puts "Enter quantity: "
quantity = gets.chomp.to_f


basket[name] = { price: price, quantity: quantity }
end


total_sum = 0


puts "\nCart contents: "
puts "-------------------"


basket.each do |name, data|
	price = data[:price]
	quantity = data[:quantity]
	item_sum = price * quantity
	total_sum += item_sum


	puts "Product: #{name}"
	puts "Price: #{price}"
	puts "Quantity: #{quantity}"
	puts "Sum: #{item_sum}"
	puts "---------------------"
end


puts "The total amount of all purchases: #{total_sum}"