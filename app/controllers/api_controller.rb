class ApiController < ApplicationController
  def test
    ad = Ad.last
    if ad.picture?
      render json: ad.picture
    end
  end
end
