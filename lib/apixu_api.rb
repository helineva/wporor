class ApixuApi
  def self.get_weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q=#{ERB::Util.url_encode(city)}"
    response = HTTParty.get url
    return response if response.key?('current')

    nil
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end
end
