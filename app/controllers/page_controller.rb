class PageController < ApplicationController

  def index
  end

  def ads
    @ads = Ad.all
  end

  def ad_new
    @ad = Ad.new
  end

  def ad_create
    @ad = Ad.new(ad_params)
    if @ad.save
      redirect_to root_path
    else
      render :ad_new
    end
  end

  def report
    render :analytics_report
  end

  def ad_request
    uri = URI.parse("http://18.182.76.60/api")
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end
    case response
    when Net::HTTPSuccess
      render html: response.body.html_safe
    end
  end

  private

  def ad_params
    params.require(:ad).permit(:name, :picture)
  end
end
