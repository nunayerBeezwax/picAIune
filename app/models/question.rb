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
		wiki_word = keyword_finder(tagged).titleize
		if self.text.include?(" ")
			search_word = self.text.titleize.gsub!(" ", "%20")
		else
			search_word = self.text.titleize
		end
		uri = URI.parse("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=#{wiki_word}&rvprop=content&format=json&rvparse=1")
		wiki_page = Nokogiri::HTML(open("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=#{wiki_word}&redirects&rvprop=content&format=json&rvparse=1"))
		File.open("picAIune.html", "w") do |f|
			f.puts wiki_page
		end
		word_count = {}
		words = File.read("picAIune.html").split(" ")
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

	def keyword_finder(tagged)
		@@tagger.get_proper_nouns(tagged).first[0]
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