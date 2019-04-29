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
      p @ad
      render :ad_new
    end
  end

  private

  def ad_params
    params.require(:ad).permit(:name, :picture)
  end
end
