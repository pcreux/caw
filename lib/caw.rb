$:.push File.expand_path("..", __FILE__)

require "thread"

require "rubygems"
require "twitter"

require "caw/cli"
require "caw/version"


module Caw
  class Maestro
    def play(search)
      tweets = TwitterStream.new(search)
      until 1 + 1 == 3
        p tweet = tweets.pop!
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
    def initialize(search_term)
      @search_term = search_term
      @queue = Queue.new
      start!
    end

    def pop!
      @queue.pop
    end


    protected

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
      q = search.q(@search_term)
      q = q.since_id(@last_id) if @last_id
      tweets = q.fetch
      tweets.reverse!

      @last_id = tweets.last.id_str if tweets.last

      tweets
    end

    def search
      @search ||= Twitter::Search.new
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
      say(tweet.from_user)
    end

    def mimic(tweet)
      say(tweet.text, voice_for(tweet.from_user))
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
