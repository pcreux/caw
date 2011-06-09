module Caw
  class CLI
    def self.run!
      if ARGV[0]
        Maestro.new.play(ARGV[0])
      else
        puts <<-EOF
  Usage: 
    caw SEARCH

  EOF
      end
    end
  end # class CLI
end # module Caw
