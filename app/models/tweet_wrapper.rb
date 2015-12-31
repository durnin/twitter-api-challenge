class TweetWrapper

  def initialize(tweet, oembed)
    @tweet = tweet
    @oembed = oembed
  end

  def get_embed_html
    @oembed.html
  end

  def self.fetch_tweets_by_screen_name(screen_name, count, include_retweets)
    errors = validate_fetch_parameters(screen_name, count, include_retweets)
    if errors.any?
      return [], errors
    else
      begin
        tweets =
          Rails.cache.fetch([screen_name, count, include_retweets], :expires_in => TwitterApiChallenge::Application.config.global_cache_expiration) do
            timeline_tweets = $twitter.user_timeline(screen_name, {:count => count, :include_rts => include_retweets})
            oembed_of_tweets = $twitter.oembeds(timeline_tweets, {:omit_script => true, :align => 'center', :maxwidth => '550'})
            wrapped_tweets = []
            timeline_tweets.zip(oembed_of_tweets).each do |tweet, oembed|
              wrapped_tweets << TweetWrapper.new(tweet, oembed)
            end
            wrapped_tweets
          end
        return tweets, []
      rescue Twitter::Error::Unauthorized => e
        errors << "Error while trying to fetch tweets for screen_name #{screen_name}: #{e.message}"
        STDERR.puts errors.last # Log the error somewhere for future analysis!
        return [], errors
      end
    end
  end

  private

  def self.validate_fetch_parameters(screen_name, count, include_retweets)
    error_messages = []
    if screen_name.blank?
      error_messages << (I18n.t 'twitter.errors.screen_name_invalid')
    end
    unless [5, 10, 25, 50].include? count
      error_messages << (I18n.t 'twitter.errors.count_invalid')
    end
    unless [true, false].include? include_retweets
      error_messages << (I18n.t 'twitter.errors.include_retweets_invalid')
    end
    error_messages
  end

end
