class ApiController < ApplicationController
  def test
    ad = Ad.last
    if ad.picture?
      tag = "https://www.google-analytics.com/collect?v=1&t=event&tid=UA-139306378-1&cid=9be51570-6797-40f3-8645-f70c64e29b32&ec=ad&ea=impression&dp=%2Fad%2Ftest"
      render partial: "ad_template", locals: { img_url: ad.picture.url, tag: tag }
    end
  end
end
