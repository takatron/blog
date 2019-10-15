# handle Voting
class VotesController < ApplicationController
  def create
    attr = params.permit(:voteable_type, :voteable_id, :user_id)
    Vote.new(attr).save

    redirect_to :back
  end
end
