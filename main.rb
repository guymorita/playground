require "sinatra"
require "sinatra/reloader"
require "movies"
require "stock_quote"
require "image_suckr"

get "/" do
  @head = "Bonjourno"
  @page = :home
  erb :index
end

get "/movies" do
  @head = "Movies"
  @page = :movies
  @background = "body {background:url('http://www.releasedonkey.com/big/TVY1Qk1UYzFORGc1TVRNek9WNUJNbDVCYW5CblhrRnRaVGN3TmpFek56SXdOQQ/picture-of-robert-de-niro-and-val-kilmer-in-heat-large-picture.jpg');background-size: cover;}"
  unless params[:film_name].nil?
    @film = Movies.find_by_title(params[:film_name])
    @suckr = ImageSuckr::GoogleSuckr.new 
    @img_url = @suckr.get_image_url({"q" => "#{params[:film_name]}"})
    erb :movie_results
  else
    erb :movies
  end
end

get "/stocks" do
  @head = "Stocks"
  @page = :stocks
  @background = "body {background:url('http://gadgetsoutlook.com/wp-content/uploads/2013/04/Nasdaq-Stock-Market.jpg');background-size: cover;}"
  unless params[:stock_tick].nil?
    begin
      @stock = StockQuote::Stock.quote(params[:stock_tick])
      erb :stock_results
    rescue
      erb :stocks
    end
  else
    erb :stocks
  end
end

get "/images" do
  @head = "Images"
  @background = "body {background:url('http://interfacelift.com/wallpaper/D47cd523/03263_sunsetatsaltlake_2880x1800.jpg');background-size: cover;}"
  @page = :images
  unless params[:image_name].nil?
    if params[:image_name] == "random"
      begin
        @rand_word = ["bear", "cat", "tiger", "polar bear", "panda bear"].sample
        @suckr = ImageSuckr::GoogleSuckr.new 
        @img_url = @suckr.get_image_url({"q" => @rand_word})
        erb :image_results
      rescue
        erb :images
      end
    else
      begin
        @suckr = ImageSuckr::GoogleSuckr.new 
        @img_url = @suckr.get_image_url({"q" => "#{params[:image_name]}", "imgsz" => "small"})
        # @img_url_background = @suckr.get_image_url({"q" => "#{params[:image_name]}", "imgsz" => "huge"})
        # @background = "body {background:url('@img_url_background');}"
        erb :image_results
      rescue
        erb :images
      end
    end
  else
    erb :images
  end
end

