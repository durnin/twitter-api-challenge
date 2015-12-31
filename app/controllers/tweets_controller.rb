class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    if tweet_search_params[:handle].nil?
      # first load, don't make any search
      @tweets = []
    else
      @handle = tweet_search_params[:handle] || ''
      number_of_tweets = tweet_search_params[:number].to_i
      include_rts = (tweet_search_params[:retweets] == 'No' ? false : true)
      @tweets, errors = TweetWrapper.fetch_tweets_by_screen_name(@handle, number_of_tweets, include_rts)
      flash.now[:alert] = errors if errors.any?
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def tweet_search_params
    params.permit(:handle, :retweets, :number)
  end
end
