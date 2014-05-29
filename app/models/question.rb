class Question < ActiveRecord::Base
require 'open-uri'
@@tagger = EngTagger.new

###################
#CHOP IT OFF AT THE "SEE ALSO" SECTION to minimize false
#reports.
###

	def find_the_answer
		choices = self.choice_array
		tagged = @@tagger.add_tags(self.text)
		if proper_nouns(tagged).length > 0
			wiki_words = proper_nouns(tagged)
			search = wiki_words.keys.join("%20")
		else
			search = nouns(tagged).keys.last
		end
		wiki_page = Nokogiri::HTML(open("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=#{search}&redirects&rvprop=content&format=json&rvparse=1"))
		File.open("tmp/picAIune.html", "w") do |f|
			f.puts wiki_page
		end
		word_count = {}
		words = File.read("tmp/picAIune.html").split(" ")
		string = words.join(" ").downcase
		sanitized_string = string.gsub(/\/[,()'":<>=.]/,'')
		answer = {}
		choices.each { |w| answer[w] = string.scan(/#{Regexp.quote(w)}/).size if w != '' }
		if !answer.values.any?{ |v| v > 0 }
			self.update(answer: "I don't know")
		else
			answer.each{|k, v| "#{k} === #{v}"}
			self.update(answer: answer.sort_by{|k, v| v}.reverse.first[0].titleize)
		end
	end

	def proper_nouns(tagged)
		@@tagger.get_proper_nouns(tagged)
	end

	def nouns(tagged)
		@@tagger.get_nouns(tagged)
	end

	def choice_array
		choices = []
		choices << self.choice1 unless self.choice1.nil?
		choices << self.choice2 unless self.choice2.nil?
		choices << self.choice3 unless self.choice3.nil?
		choices << self.choice4 unless self.choice4.nil?
		choices
	end

	def parse_question(string)
		string = string.downcase
		array = string.split(" ")
		if array.include?("is")
			operative_word = array[array.index("is") + 1]
		end
		;lkajsdf;lkasjdf
	end
end