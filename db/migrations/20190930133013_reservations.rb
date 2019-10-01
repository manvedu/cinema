Sequel.migration do
  change do
    create_table(:reservations) do
      primary_key :id
      foreign_key :showtime_id, :showtimes
      Integer :identity_number, :null => false
      Integer :number_of_people, :null => false, :default => 1
      index :identity_number
    end
  end
end
