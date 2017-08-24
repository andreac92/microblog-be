class DeploysController < ApplicationController
	before_action :authenticate_user!

	def deploy
		netlify = NetlifyDeploy.new current_user, params[:layout]
		url = netlify.deploy

		if !url
			render json: {}, status: :unprocessable_entity
		else
			render json: {url: url}, status: :ok
		end
	end

end