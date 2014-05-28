class Question < ActiveRecord::Base
require 'open-uri'

	def find_the_answer
		choices = []
		choices << self.choice1
		choices << self.choice2
		choices << self.choice3
		choices << self.choice4
		if self.text.include?(" ")
			search_word = self.text.titleize.gsub!(" ", "%20")
		else
			search_word = self.text.titleize
		end
		uri = URI.parse("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=#{search_word}&rvprop=content&format=json&rvparse=1")
		wiki_page = Nokogiri::HTML(open("http://en.wikipedia.org/w/api.php?action=query&prop=revisions&titles=#{search_word}&rvprop=content&format=json&rvparse=1"))
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
end