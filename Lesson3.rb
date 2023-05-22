print "Enter the lenght of the first side of the triagle: "
side1 = gets.chomp.to_f

print "Enter the lenght of the second side of the triagle: "
side2 = gets.chomp.to_f

print "Enter the lenght of the third side of the triagle: "
side3 = gets.chomp.to_f

hypotenuse = side1

if side2 > hypotenuse
	hypotenuse = side2
elsif side3 > hypotenuse
	hypotenuse = side3
end

if side1 == side2 && side2 == side3
	puts "The triangle is equilateral"

elsif side1 == side2 || side2 == side3 || side1 == side3
	puts "The triangle is isosceles"

elsif hypotenuse**2 == side1**2 + side2**2 || hypotenuse**2 == side2**2 + side3**2 || hypotenuse**2 == side1**2 + side3**2
	puts "The triangle is right angled"

else
	puts "The triangle is neither equilateral, isosceles, nor right"
end