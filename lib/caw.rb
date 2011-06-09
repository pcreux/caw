$:.push File.expand_path("..", __FILE__)

require "thread"

require "rubygems"
require "twitter"

require "caw/cli"
require "caw/version"


module Caw
  class Maestro
    def play(key, secret, token, token_secret)
      tweets = TwitterStream.new(key, secret, token, token_secret)
      until 1 + 1 == 3
        tweet = tweets.pop!
        tweet.text = enhance_text(tweet.text)
        Mimic.say(tweet)
      end
    end

    def enhance_text(text)
      puts text
      text.gsub!(/http:\S+/, '')
      text.gsub!(/RT @/, 'Retweet ')
      text.gsub!(/@/, 'At ')
      puts text

      text
    end
  end # class Maestro


  class TwitterStream
    def initialize(key, secret, token, token_secret)
      setup_twitter(key, secret, token, token_secret)
      @queue = Queue.new
      start!
    end

    def pop!
      @queue.pop
    end


    protected

    def setup_twitter(key, secret, token, token_secret)
      Twitter.configure do |config|
        config.consumer_key = key
        config.consumer_secret = secret
        config.oauth_token = token
        config.oauth_token_secret = token_secret
      end
    end

    def start!
      Thread.new do
        while run?
          enqueue_new_tweets
          sleep 10
        end
      end
    end

    def run?
      true
    end

    def enqueue_new_tweets
      new_tweets.each do |t| 
        puts "Enqueuing: #{t.text}"
        @queue << t
      end
    end

    # Return new tweets last comes first
    def new_tweets
      tweets = @last_id ? client.home_timeline(:since_id => @last_id) : client.home_timeline
      tweets.reverse!

      @last_id = tweets.last.id_str if tweets.last

      tweets
    end

    def client
      @client ||= Twitter::Client.new
    end
  end # class TwitterStream

  class Mimic
    def self.say(tweet)
      mimic.announce(tweet)
      mimic.mimic(tweet)
    end

    def self.mimic
      @mimic ||= new
    end

    VOICES = %w(Bruce Fred Junior Ralph)

    def announce(tweet)
      say(tweet.user.name)
    end

    def mimic(tweet)
      say(tweet.text, voice_for(tweet.user.name))
    end

    protected

    def say(txt, voice = 'Alex')
      txt ||= ''
      puts "Saying: #{txt}"
      system("say -v '#{voice}' '#{txt.gsub("'", "")}'")
    end

    def voice_for(name)
      VOICES.at(name[1] % VOICES.length)
    end
  end # class Mimic
end
