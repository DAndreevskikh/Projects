class CargoWagon < Wagon
  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    super(:cargo)
    @total_volume = total_volume
    @occupied_volume = 0
  end

  def occupy_volume(volume)
    raise 'Not enough free volume.' if @occupied_volume + volume > @total_volume

    @occupied_volume += volume
  end

  def free_volume
    @total_volume - @occupied_volume
  end
end
