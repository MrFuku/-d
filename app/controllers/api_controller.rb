
class ApiController < ApplicationController
  def test
    ad = Ad.offset( rand(Ad.count) ).first
    if ad.picture?
      impression_tag = "https://www.google-analytics.com/collect?v=1&t=event&tid=UA-139306378-1&cid=9be51570-6797-40f3-8645-f70c64e29b32&ec=ad&ea=impression&dp=%2Fad%2Fimpression%2F#{ad.id}"
      click_tag = "https://www.google-analytics.com/collect?v=1&t=event&tid=UA-139306378-1&cid=9be51570-6797-40f3-8645-f70c64e29b32&ec=ad&ea=impression&dp=%2Fad%2Fclick%2F#{ad.id}"
      render partial: "ad_template", locals: { img_url: ad.picture.url, impression_tag: impression_tag, click_tag: click_tag }
    end
  end

  def analytics
    api = GaApi.new
    api.authorize!
    dimensions = "ga:date"
    start_date = params["startTerm"]
    end_date = params["endTerm"]
    filters_for_impression = "ga:pagePath==/ad/impression/#{params[:ad_id]}"
    filters_for_click = "ga:pagePath==/ad/click/#{params[:ad_id]}"
    if params["select_value"]=="1"
      dimensions += ",ga:hour"
    elsif params["select_value"]=="2"
      start_date += "-01"
      end_date = Date.parse(start_date).end_of_month.strftime("%Y-%m-%d")
      start_date = Date.parse(start_date).strftime("%Y-%m-%d")
    else
      difTime = (Date.parse(end_date) - Date.parse(start_date)).to_i
      return if(difTime>60)
    end
    analytics = api.get_data( start_date: start_date, end_date: end_date, dimensions: dimensions, filters: filters_for_impression )
    analytics  = JSON.parse(analytics.response.body)
    impression_result = analytics["rows"]
    analytics = api.get_data( start_date: start_date, end_date: end_date, dimensions: dimensions, filters: filters_for_click )
    analytics  = JSON.parse(analytics.response.body)
    click_result = analytics["rows"]
    render json: [impression_result, click_result]
  end
end
