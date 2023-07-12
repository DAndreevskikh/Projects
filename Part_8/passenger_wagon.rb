class PassengerWagon < Wagon
  attr_reader :total_seats, :occupied_seats

  def initialize(total_seats)
    super(:passenger)
    @total_seats = total_seats
    @occupied_seats = 0
  end

  def occupy_seat
    raise 'All seats are occupied.' if @occupied_seats >= @total_seats

    @occupied_seats += 1
  end

  def free_seats
    @total_seats - @occupied_seats
  end
end
