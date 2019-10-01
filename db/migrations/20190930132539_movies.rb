Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :name, :null => false, :unique => true
      String :description, :null => false
      # use paperclip??
      String :image_url, :null => false, :unique => true
      #String :days, :null => false it is not for the movie it is for the 'funcion de cine' showtime
    end
  end
end
