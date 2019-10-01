module Services
  class ListCreator
    DAYS = {"lunes" => 1, "martes" => 2, "miercoles" => 3, "jueves" => 4, "viernes" => 5, "sabado" => 6, "domingo" => 7}

    def initialize(params)
      @params = params
    end

    def list_movies
      day = DAYS[@params["day"].downcase]
      movies = Showtime.where(day_of_the_week: day).map{ |m| m.movie }.map{ |m| m.values }
      { movies: movies }
    end

    def list_reservations
      reservations = Showtime.where(date: @params["initial_date"]..@params["end_date"]).map{ |st| st.reservations }.flatten
      reservations = reservations.map{ |r| r.values }
      { :reservations => reservations }
    end

  end
end
