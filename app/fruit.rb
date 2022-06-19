class Fruit
  attr_accessor :coordinate_x, :coordinate_y

  def initialize(coordinate_x, coordinate_y)
    @coordinate_x = coordinate_x
    @coordinate_y = coordinate_y
  end

  def there?(x, y)
    coordinate_x == x && coordinate_y == y
  end
end
