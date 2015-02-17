require 'sinatra'
require 'sinatra/reloader'
require 'better_errors'
require 'pry'
require 'pg'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

set :conn, PG.connect(dbname: 'squad_lab') # key and value 

before do
  @conn = settings.conn
end

# ROOT ROUTE — Shows nothing so redirect it to the index route with an erb page
get '/' do
  redirect to '/houses'
end

# INDEX // SHOW HOUSES — Route that shows all the houses
get '/houses' do
  # Create a HOUSE var as an empty array
  # As you loop, push new houses into the houses array
  houses = []
  @conn.exec("SELECT * FROM house") do |result| #SQL query to get me all the results of the house table
    result.each do |house|
      houses << house
    end
  end
  @houses = houses # Creating an instance variable for house to call in index erb
  erb :index
end

# SHOW FORM TO CREATE NEW HOUSE — Route that shows a form that allows user to create a new house
get '/houses/new' do
  erb :new
end

# SHOW HOUSE — Route that shows information about a single house
get '/houses/:house_id' do
  house_id = params[:house_id].to_i
  house = @conn.exec("SELECT * FROM house WHERE id = ($1)", [house_id]) 
  @house = house[0] # So that only the item at 0 index is returned— Also the first of the array
  erb :show
end

# SHOW FORM TO EDIT HOUSE — Route that shows a form that allows user to edit an existing house
get '/houses/:house_id/edit' do 
  house_id = params[:house_id].to_i
  house = @conn.exec("SELECT * FROM house WHERE id = ($1)", [house_id]) 
  @house = house[0] # So that only the item at 0 index is returned— Also the first of the array
  erb :edit
end

# SHOW HOUSE STUDENTS — Route that shows all students for an individual house
get '/houses/:house_id/students' do
end

# SHOW STUDENT OF HOUSE — Route that shows information about an individual student in a house
get '/houses/:house_id/students/:student_id' do
end

# SHOW FORM TO NEW STUDENT OF HOUSE — Route that shows a form to create a new student for a house
get '/houses/:house_id/students/new' do
end

# SHOW FORM TO EDIT STUDENT OF HOUSE — Route that shows a form to edit a student's information
get '/houses/:house_id/students/:student_id/edit' do
end

# CREATE HOUSE — Route used for creating a new house
post '/houses' do
end

# CREATE STUDENT — Route used for creating a new student in an existing house
post '/houses/:house_id/students' do
end

# UPDATE HOUSE – Route used for editing an existing house
put '/houses/:house_id' do
end

# UPDATE STUDENT — Route used for editing an existing student in a house
put '/houses/:house_id/students' do
end

# DESTROY HOUSE — Route used for deleting an existing house
delete '/houses/:house_id' do
end

# DESTROY STUDENT — Route used for deleting an existing student in a house
delete '/houses/:house_id/students/:student_id' do
end
