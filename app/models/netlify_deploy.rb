require 'fileutils'
require 'erb'
require 'zip'
require 'rest-client'

class NetlifyDeploy
	INDEX_TEMP =  Rails.root.join('app', 'views', 'layouts', 'index.html.erb')
	CSS_FILE = Rails.root.join('sites', 'stylesheets', 'style.css')
	
	def initialize user, layout
		@url = 'https://api.netlify.com/api/v1/'
		@token = Rails.application.secrets.netlify_token
		@user = user
		@layout = layout
	end

	def deploy
		return false if !@user.site_id.present? && !create_site 

		generate_index_file

		make_zip
		send_zip
	end

	def create_site
		response = RestClient.post(@url + 'sites?access_token=' + @token)

		return false if response.code != 200

		data = JSON.parse(response.body)
		@user.update_attributes(site_id: data.site_id)
	end
	
	def generate_index_file
		contents = File.read(INDEX_TEMP)
		@name = @user.name
		@posts = @user.posts

		puts @posts
		renderer = ERB.new(contents)
		result = renderer.result(binding)

		FileUtils.mkdir_p(Rails.root.join('sites', @user.site_id))
		index_file = Rails.root.join('sites', @user.site_id, 'index.html')
		File.delete(index_file) if File.exist?(index_file)

		File.open(index_file, 'w') do |f|
		  f.write(result)
		end
	end

	def make_zip
		site_zip = Rails.root.join('sites', @user.site_id, 'site.zip')

		File.delete(site_zip) if File.exist?(site_zip)

		Zip::File.open(site_zip, Zip::File::CREATE) do |zipfile|
		    zipfile.add('index.html', Rails.root.join('sites', @user.site_id, 'index.html'))
		    zipfile.add('style.css', CSS_FILE)
		end
	end

	def send_zip
		site_zip = Rails.root.join('sites', @user.site_id, 'site.zip')
		file = File.open(site_zip, 'rb') { |io| io.read }

		headers = {
			'Authorization' => "Bearer #{@token}",
			'Content-Type' => 'application/zip'
		}
		response = RestClient.post(@url + 'sites/' + @user.site_id + '/deploys', file, headers)
		return nil if response.code != 200

		data = JSON.parse(response.body)
		data['url']
	end
end