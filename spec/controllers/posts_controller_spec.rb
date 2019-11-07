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
  end
end
