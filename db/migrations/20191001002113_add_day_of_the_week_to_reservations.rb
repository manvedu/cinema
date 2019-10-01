Sequel.migration do
  up do
    add_column :showtimes, :day_of_the_week, Integer
  end

  down do
    drop_column :showtimes, :day_of_the_week
  end
end
