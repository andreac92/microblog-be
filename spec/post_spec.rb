require "rails_helper"

RSpec.describe PostsController, :type => :controller do
	describe 'get list of posts' do
		it "suceeds with proper authentication" do
			user = User.create(email: 'user@ha.com', name: 'Jane Doe', password: 'netlify123')
			user.posts.create(content: 'Test post!!!!!')

			headers = user.create_new_auth_token
			request.headers.merge!(headers)

			get :index
			expect(response.content_type).to eq("application/json")
    		expect(response).to have_http_status(:ok)

    		json = JSON(response.body)
    		expect(json.length).to eq(1)
		end

		it "fails without proper authentication" do
			user = User.create(email: 'user@ha.com', name: 'Jane Doe', password: 'netlify123')
			user.posts.create(content: 'Test post!!!!!')


			get :index
    		expect(response).to have_http_status(401)
		end
	end

	describe 'creates a post' do
		it "succeeds with proper authentication" do
			user = User.create(email: 'user@ha.com', name: 'Jane Doe', password: 'netlify123')

			headers = user.create_new_auth_token
			request.headers.merge!(headers)

			post :create, params: { content: 'hey' }
			expect(response.content_type).to eq("application/json")
    		expect(response).to have_http_status(:created)
		end
	end

	describe 'deletes a post' do
		it "succeeds with proper authentication" do
			user = User.create(email: 'user@ha.com', name: 'Jane Doe', password: 'netlify123')
			user.posts.create(content: 'Test post!!!!!')

			headers = user.create_new_auth_token
			request.headers.merge!(headers)

			delete :destroy, params: { id: user.posts.first.id }
    		expect(response).to have_http_status(:no_content)
		end
	end
end