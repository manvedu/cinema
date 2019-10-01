Sequel.migration do
  change do
    create_table(:showtimes) do
      primary_key :id
      foreign_key :movie_id, :movies
      Date :date, :null => false
      Integer :available_capacity, :null => false, :default => 10
    end
  end
end
