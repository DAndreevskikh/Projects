class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = [] # Массив для хранения поездов, находящихся на станции
  end
  # Принимает поезд на станцию
  def take_train(train)
    @trains << train
  end
  # Удаляет поезд из списка поездов на станции
  def delete_train(train)
    @trains.delete(train)
  end
  # Возвращает список поездов на станции по типу
  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end
