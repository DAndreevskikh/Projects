fib = [0, 1]

while 
	(next_number = fib[-1] + fib[-2]) < 100
	fib << next_number
	end

	puts fib.inspect
