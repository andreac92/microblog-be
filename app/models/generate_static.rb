require 'fileutils'
require 'erb'

class NetlifyDeploy
	INDEX_TEMP =  Rails.root.join('app', 'views', 'layouts', 'index.html.erb')
	INDEX_FILE =  Rails.root.join('sites', 'index.html')

	
	
	def generate_index_file user
		contents = File.read(INDEX_TEMP)
		@name = user.name
		@posts = user.posts

		puts @posts
		renderer = ERB.new(contents)
		result = renderer.result(binding)

		File.open(INDEX_FILE, 'w') do |f|
		  f.write(result)
		end
	end
end