module Caw
  class CLI
    def self.run!
      if ARGV[0] && ARGV[1] && ARGV[2] && ARGV[3]
        Maestro.new.play(ARGV[0], ARGV[1], ARGV[2], ARGV[3])
      else
        puts <<-EOF
  Usage: 
    caw YOUR_TWITTER_KEY YOUR_TWITTER_SECRET YOUR_OAUTH_TOKEN YOUR_OAUTH_TOKEN_SECRET

  EOF
      end
    end
  end # class CLI
end # module Caw
