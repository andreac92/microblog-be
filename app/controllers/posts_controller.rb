class PostsController < ApplicationController
	before_action :authenticate_user!

	def index
		posts = current_user.posts
		render json: posts, status: :ok
	end

	def create
		post = current_user.posts.build(content: params[:content])
		if post.save
			render json: post, status: :created
		else
			render json: { errors: post.errors }, status: :unprocessable_entity
		end
	end

	def update
		post = Post.find(params[:id])

		if post.update(content: params[:content])
			render json: post, status: :ok
		else
			render json: { errors: post.errors }, status: :unprocessable_entity
		end
	end

	def destroy
		post = Post.find(params[:id])

		if post.destroy
			render json: {}, status: :no_content
		else
			render json: { errors: post.errors }, status: :unprocessable_entity
		end
	end
end