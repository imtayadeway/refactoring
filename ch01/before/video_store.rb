class Movie
  CHILDRENS = 2
  REGULAR = 0
  NEW_RELEASE = 1

  attr_accessor :price_code
  attr_reader :title

  def initialize(title, price_code)
    @title = title
    @price_code = price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
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
    total_amount = 0.0
    frequent_renter_points = 0
    result = "Rental Record for #{ name }\n"
    rentals.each do |rental|
      this_amount = 0

      # determine amounts for each line
      case rental.movie.price_code
      when Movie::REGULAR
        this_amount += 2

        if rental.days_rented > 2
          this_amount += (rental.days_rented - 2) * 1.5
        end
      when Movie::NEW_RELEASE
        this_amount += rental.days_rented * 3
      when Movie::CHILDRENS
        this_amount += 1.5

        if rental.days_rented > 3
          this_amount += (rental.days_rented - 3) * 1.5
        end
      end

      # add frequent renter points
      frequent_renter_points += 1

      # add bonus for a two day new release rental
      if rental.movie.price_code == Movie::NEW_RELEASE && rental.days_rented > 1
        frequent_renter_points += 1
      end

      # show figures for this rental
      result += "\t#{ rental.movie.title }\t#{ this_amount}\n"
      total_amount += this_amount
    end

    # add footer lines
    result += "Amount owed is #{ total_amount }\n"
    result += "You earned #{ frequent_renter_points } frequent renter points"
    result
  end

  private

  attr_reader :rentals
end
