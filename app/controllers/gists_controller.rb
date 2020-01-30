# integrating with Github
class GistsController < ApplicationController
  def index
    @gists = []
  end

  def search
    con = Faraday.new("https://api.github.com/users/#{params[:username]}/gists")

    @gists = JSON.parse(con.get.body)

    render 'index'
  end
end
