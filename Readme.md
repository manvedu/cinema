# Welcome Movie API!

Hi! 

Using this API you can create movies, showtimes and reservations for a Cinema. Additional you can search for movies using day of the week or reservations given date range.

You can find the app in heroku

**https://cinema-test-maria.herokuapp.com/api/status**


# Dependencies

This project requires postgres

# Installation
- Clone project from **git@github.com:manvedu/cinema.git**
- Install bundler `gem install bundler`
- Install gems ` bundle`
- Create database 
- Run migrations `bundle exec rake db:migrate`


## Run app

- Config in your `.env` file the variable  `DATABASE_URL`
```
DATABASE_URL='postgres://host/db_name'
```

- Run command
```
bundle exec rackup -p 9292 config.ru
```

Now your app is running at localhost:9292

## Run tests
- Run command
```
bundle exec rspec spec/
```
 
 # API endpoints
 - GET /status
 
 Health check endpoint 

Request:
```
http://localhost:9292/api/status
```

Response 
 
```
{
  "status":"ok"
}
```

 - POST /api/v1/movies
 
It creates a movie
 Request
```
curl -X POST 
-H "Content-Type: application/json" 
-d '{
       "name":"Finding Dory", 
       "description":"A fish lost her parents", 
       "image_url":"https://url_to_image",
    }' 
http://localhost:9292/api/v1/movies 
```
Parameters description
<table>
  <tr>
    <th>Param name</th>
    <th>Description</th>
    <th>Type</th>
    <th>Required</th>
    <th>Restrictions</th>
  </tr>
  <tr>
    <td>name</td>
    <td>Name of the movie</td>
    <td>String</td>
    <td>true</td>
    <td>There can be no more of one movie with the same name</td>
  </tr>
  <tr>
    <td>description</td>
    <td>Brief data about the movie</td>
    <td>String</td>
    <td>true</td>
    <td></td>
  </tr>
  <tr>
    <td>image_url</td>
    <td>URL to the image movie poster</td>
    <td>String</td>
    <td>true</td>
    <td>There can be no more of one movie with the same image_url</td>   
  </tr>
</table>

Response
```
{
  "id":1,
  "name":"Finding Dory",
  "description":"A fish lost her parents",
  "image_url":"https://url_to_image"
}
  ```

 - GET /api/v1/movies
 
It list movies giving a day of the week
 Request
```
curl -X GET -H "Content-Type: application/json" 
http://localhost:9292/api/v1/movies?day=lunes
```
Parameters description
<table>
  <tr>
    <th>Param name</th>
    <th>Description</th>
    <th>Type</th>
    <th>Required</th>
    <th>Restrictions</th>
  </tr>
  <tr>
    <td>day</td>
    <td>Name of day</td>
    <td>String</td>
    <td>true</td>
    <td>It has to be name of day of the week in spanish</td>
  </tr>
  </table>

Response
```
{
"movies":
  [
    {
      "id":1,
      "name":"Finding Dory",
      "description":"A fish lost her parents",
      "image_url":"https://url_to_image"
    },
    {
      "id":2,
      "name":"Finding Nemo",
      "description":"Two fishes search a lost fish",
      "image_url":"https://url_to_image_2"
    },
  ]
}
  ```

 - POST /api/v1/showtimes
 
It creates a showtime
 Request
```
curl -X POST 
-H "Content-Type: application/json" 
-d '{
       "movie_id": 1,
       "date":"2019-10-20" 
    }' 
http://localhost:9292/api/v1/showtimes 
```

Parameters description
<table>
  <tr>
    <th>Param name</th>
    <th>Description</th>
    <th>Type</th>
    <th>Required</th>
    <th>Restrictions</th>
  </tr>
  <tr>
    <td>movie_id</td>
    <td>Id of the movie associated</td>
    <td>Integer</td>
    <td>true</td>
    <td>It has to be for an existing movie</td>
  </tr>
   <tr>
    <td>date</td>
    <td>Date when the movie will be presenting</td>
    <td>String</td>
    <td>true</td>
    <td>It has to have format YYYY-mm-dd</td>
  </tr>
  </table>

Response
```
{
  "id":1,
  "movie_id": 1,
  "date": "2019-10-20",
  "available_capacity": 10,
  "day_of_the_week": 7,
}
  ```

 - POST /api/v1/reservations
 
It creates a reservation
 Request
```
curl -X POST 
-H "Content-Type: application/json" 
-d '{
       "showtime_id":5,
       "identity_number":1234567,   
       "number_of_people":3
    }' 
http://localhost:9292/api/v1/reservations 
```
Parameters description
<table>
  <tr>
    <th>Param name</th>
    <th>Description</th>
    <th>Type</th>
    <th>Required</th>
    <th>Restrictions</th>
  </tr>
  <tr>
    <td>showtime_id</td>
    <td>Id of the showtime associated</td>
    <td>Integer</td>
    <td>true</td>
    <td>It has to be for an existing showtime</td>
  </tr>
   <tr>
    <td>identity_number</td>
    <td>Identity number for a person (C.C.)</td>
    <td>Integer</td>
    <td>true</td>
    <td></td>
  </tr>
     <tr>
    <td>number_of_people</td>
    <td>number of people in the reservation</td>
    <td>Integer</td>
    <td>true</td>
    <td>It can not be more than 10 or number available capacity has the showtime</td>
  </tr>
  </table>

Response
```
{
  "id":1,
  "showtime_id": 1,
  "identity_number":1234567,
  "number_of_people":3
}
  ```

 - GET /api/v1/reservations
 
It list reservations giving a range of dates
 Request
```
curl -X GET
-H "Content-Type: application/json" 
http://localhost:9292/api/v1/reservations?initial_date=2019-10-20&end_date=2019-10-23
```
Parameters description
<table>
 <tr>
    <td>initial_date</td>
    <td>First date for searching movies with associated showtimes</td>
    <td>String</td>
    <td>true</td>
    <td>It has to have format YYYY-mm-dd</td>
  </tr>
   <tr>
    <td>end_date</td>
    <td>End date for searching movies with associated showtimes</td>
    <td>String</td>
    <td>true</td>
    <td>It has to have format YYYY-mm-dd</td>
  </tr>
</table>

Response
```
{
  "reservations":
    [
      {
        "id":1,
        "showtime_id":5,
        "identity_number":1234567,
        "number_of_people":3
      },
      {
         "id":2,
         "showtime_id":1,
         "identity_number":1234567,
         "number_of_people":8
      }
    ]
}
  ```
