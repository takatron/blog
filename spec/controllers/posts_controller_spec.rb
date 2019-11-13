require 'rails_helper'

describe PostsController do
  describe '#show' do
    let(:post) { create(:post) }

    context 'when post is found using id' do
      it 'renders the show page' do
        get :show, id: post.id

        expect(response).to render_template(:show)
      end
    end

    context 'when post is found using slug' do
      it 'renders the show page' do
        get :show, id: post.slug

        expect(response).to render_template(:show)
      end
    end

    context 'when post is not found' do
      it 'renders the 404 page' do
        get :show, id: 2

        expect(response).to render_template('shared/not_found')
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#create' do
    context 'when the post is successfully created' do
      let(:user) { create(:user) }
      let(:valid_params) do
        {
          post: { title: 'my title', content: 'my content' }
        }
      end

      it 'creates the post' do
        expect {
          post :create, valid_params, { user_id: user.id }
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the posts_path' do
        post :create, valid_params, { user_id: user.id }

        expect(response).to redirect_to(posts_path(page: 1))
      end
    end

    context 'when the post fails creation' do
      let(:user) { create(:user) }
      let(:invalid_params) do
        {
          post: { title: '', content: '' }
        }
      end

      it 'does not create a post' do
        expect {
          post :create, invalid_params, { user_id: user.id }
        }.not_to change(Post, :count)
      end

      it 'renders the new template' do
        post :create, invalid_params, { user_id: user.id }

        expect(response).to render_template(:new)
      end
    end
  end
end
