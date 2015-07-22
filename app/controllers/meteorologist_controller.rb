require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================
    latlng_url="https://maps.googleapis.com/maps/api/geocode/json?address=" + url_safe_street_address
    latlng_parsed_data = JSON.parse(open(latlng_url).read)

    lat = latlng_parsed_data["results"][0]["geometry"]["location"]["lat"]
    lng = latlng_parsed_data["results"][0]["geometry"]["location"]["lng"]

    met_url="https://api.forecast.io/forecast/98910409e9728e6c52240c2bf1185a6b/" + lat.to_s + "," + lng.to_s
    parsed_data = JSON.parse(open(met_url).read)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
