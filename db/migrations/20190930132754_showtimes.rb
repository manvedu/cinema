Sequel.migration do
  change do
    create_table(:showtimes) do
      primary_key :id
      foreign_key :movie_id, :movies
      String :date, :null => false
      Integer :available_capacity, :null => false, :default => 10
    end
  end
end
