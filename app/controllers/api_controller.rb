class ApiController < ApplicationController
  def test
    ad = Ad.last
    if ad.picture?
      render partial: "ad_template", locals: { img_url: ad.picture.url}
    end
  end
end
