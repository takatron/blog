require 'rails_helper'

describe PostsController do
  describe '#show' do
    context 'when post is found' do
      let(:post) { create(:post) }
      it 'renders the show page' do
        get :show, id: post.id

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
end
