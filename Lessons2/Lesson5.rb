print "Enter the day: "
day = gets.chomp.to_i

print "Enter month: "
month = gets.chomp.to_i

print "Enter year: "
year = gets.chomp.to_i


leap_year =	(year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) 


days_in_month = [32, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
original_day = 0


(1..month - 1).each do |m|
	original_day += days_in_month[m - 1]
end


original_day += day


original_day += 1 if leap_year &&  month > 2


puts "Date serial number: #{original_day}" 
