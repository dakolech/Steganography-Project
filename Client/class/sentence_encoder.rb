class SentenceEncoder
    def initialize
        @firstnames = File.readlines('../data/generate/popular-both-first.txt')
        @lastnames  = File.readlines('../data/generate/popular-last.txt')
        @adjectives = File.readlines('../data/generate/adjectives.txt')
        @animals    = File.readlines('../data/generate/animals.txt')
        @bodyparts  = File.readlines('../data/generate/bodyparts.txt')
    end

    def generate(options = {})
        id  = options[:id]
        key = options[:key]

        verb = options[:verb]

        puts "id is nil" if id.nil?
        puts "key is nil" if key.nil?
        puts "verb is nil" if verb.nil?
    end
end

s = SentenceEncoder.new
s.generate(id: 1234, key: 'BEZLITOSNY2')
