require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "0329940053e738bed5b2dedd3528c6dd"

# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=db57c13f926c400bba4a5c27acd1a5c9"
# news is now a Hash you can pretty print (pp) and parse for your output

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
    @location = params["location"]
    @results = Geocoder.search(params["location"])
    @lat_long = @results.first.coordinates # => [lat, long]
    @coordinates = "#{@lat_long[0]}, #{@lat_long[1]}"

    #Geocoder Results
    @forecast = ForecastIO.forecast(@lat_long[0], @lat_long[1]).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @conditions = @forecast["currently"]["summary"]


    @daily_array = @forecast["daily"]["data"]

    #IGNORE NEXT SECTION - this is using individual pulls, not loops
    @day_0 = Time.at(@daily_array[0]["time"]).strftime("%a")
    @day_1 = Time.at(@daily_array[1]["time"]).strftime("%a")
    @day_2 = Time.at(@daily_array[2]["time"]).strftime("%a")
    @day_3 = Time.at(@daily_array[3]["time"]).strftime("%a")
    @day_4 = Time.at(@daily_array[4]["time"]).strftime("%a")
    @day_5 = Time.at(@daily_array[5]["time"]).strftime("%a")
    @day_6 = Time.at(@daily_array[6]["time"]).strftime("%a")
    @day_7 = Time.at(@daily_array[7]["time"]).strftime("%a")
    
    @Day_plus1_high = @daily_array[1]["temperatureHigh"]
    @Day_plus2_high = @daily_array[2]["temperatureHigh"]
    @Day_plus3_high = @daily_array[3]["temperatureHigh"]
    @Day_plus4_high = @daily_array[4]["temperatureHigh"]
    @Day_plus5_high = @daily_array[5]["temperatureHigh"]
    @Day_plus6_high = @daily_array[6]["temperatureHigh"]
    @Day_plus7_high = @daily_array[7]["temperatureHigh"]

    @Day_plus1_summary = @daily_array[1]["summary"]
    @Day_plus2_summary = @daily_array[2]["summary"]
    @Day_plus3_summary = @daily_array[3]["summary"]
    @Day_plus4_summary = @daily_array[4]["summary"]
    @Day_plus5_summary = @daily_array[5]["summary"]
    @Day_plus6_summary = @daily_array[6]["summary"]
    @Day_plus7_summary = @daily_array[7]["summary"]
    
    #Headline
    @news = HTTParty.get(url).parsed_response.to_hash
    @headline_array = @news["articles"]

    @article1_title = @news["articles"][0]["title"]
    @article1_link = @news["articles"][0]["url"]
    @article1_content = @news["articles"][0]["content"]

    @article2_title = @news["articles"][1]["title"]
    @article2_link = @news["articles"][1]["url"]
    @article2_content = @news["articles"][1]["content"]

    @article3_title = @news["articles"][2]["title"]
    @article3_link = @news["articles"][2]["url"]
    @article3_content = @news["articles"][2]["content"]

    @article4_title = @news["articles"][3]["title"]
    @article4_link = @news["articles"][3]["url"]
    @article4_content = @news["articles"][3]["content"]

    #random image generator
    @rand_img1 = rand(1..200)
    @rand_img2 = rand(201..400)
    @rand_img3 = rand(401..600)
    @rand_img4 = rand(601..800)

    view "news"
end

# pp @news
