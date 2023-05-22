print "Enter coefficient a: "
a = gets.chomp.to_f

print "Enter coefficient b: "
b = gets.chomp.to_f

print "Enter coefficient c: "
c = gets.chomp.to_f

discriminant = b**2 - 4 * a * c 

if discriminant > 0

x1 = (-b + Math.sqrt(discriminant)) / (2 * a) 
x2 = (-b - Math.sqrt(discriminant)) / (2 * a)

puts "Discriminant: #{discriminant}"
puts "Root x1: #{x1}"
puts "Root x2: #{x2}"
elsif discriminant == 0
	x = -b / (2 * a)

	puts "Discriminant: #{discriminant}"
	puts "Root: #{x}"
else 
	puts "Discriminant: #{discriminant}"
	puts "No Roots"
end
	