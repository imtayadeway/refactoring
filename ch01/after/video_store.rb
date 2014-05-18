class Movie
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  attr_reader :title

  def initialize(title, price_code)
    @title = title
    self.price_code = price_code
  end

  def price_code
    price.price_code
  end

  def price_code=(arg)
    case arg
    when REGULAR then self.price = RegularPrice.new
    when CHILDRENS then self.price = ChildrensPrice.new
    when NEW_RELEASE then self.price = NewReleasePrice.new
    else raise ArgumentError, "Incorrect Price Code"
    end
  end

  def charge(days_rented)
    price.charge(days_rented)
  end

  def frequent_renter_points(days_rented)
    price.frequent_renter_points(days_rented)
  end

  private

  attr_accessor :price
end

class Price
  def price_code
    raise NotImplementedError
  end

  def charge
    raise NotInplementedError
  end

  def frequent_renter_points(days_rented)
    1
  end
end

class ChildrensPrice < Price
  def price_code
    Movie::CHILDRENS
  end

  def charge
    if days_rented > 3
      1.5 + (days_rented - 3) * 1.5
    else
      1.5
    end
  end
end

class NewReleasePrice < Price
  def frequent_renter_points(days_rented)
    days_rented > 1 ? 2 : 1
  end

  def price_code
    Movie::NEW_RELEASE
  end

  def charge
    days_rented * 3
  end
end

class RegularPrice < Price
  def price_code
    Movie::REGULAR
  end

  def charge
    if days_rented > 2
      2 + (days_rented - 2) * 1.5
    else
      2
    end
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end

  def charge
    movie.charge(days_rented)
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    rentals << rental
  end

  def statement
    result = "Rental Record for #{ name }\n"

    rentals.each do |rental|
      result += "\t#{ rental.movie.title }\t#{ rental.charge }\n"
    end

    result += "Amount owed is #{ total_charge }\n"
    result += "You earned #{ total_frequent_renter_points } "
    result += "frequent renter points"
    result
  end

  def html_statement
    result = "<h1>Rentals for <em>#{ name }<\em><\h1><p>\n"

    rentals.each do |rental|
      result += "#{ rental.movie.title }: #{ rental.charge }<br>\n"
    end

    result += "<p>You owe <em>#{ total_charge }<\em><p>\n"
    result += "On this rental you earned <em>#{ total_frequent_renter_points }"
    result += "<\em> frequent renter points<p>"
    result
  end

  private

  attr_reader :rentals

  def total_frequent_renter_points
    rentals.inject(0) { |sum, rental| sum + rental.frequent_renter_points }
  end

  def total_charge
    rentals.inject(0.0) { |sum, rental| sum + rental.charge }
  end
end
