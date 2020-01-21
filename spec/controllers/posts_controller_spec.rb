require 'rails_helper'
require 'json_expressions/minitest'

describe PostsController do
  describe '#show' do
    let!(:post) { create(:post) }

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
      let!(:user) { create(:user) }
      let!(:valid_params) do
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
      let!(:user) { create(:user) }
      let!(:invalid_params) do
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

  describe '#index' do
    context 'when request is Json' do
      let(:payload) do
        [
          {
            id: 1,
            title: 'my title',
            content: 'my content',
            categories: ['blogs'],
            vote_count: 1,
            author: {
              id: 7,
              firstname: 'john',
              lastname: 'doe'
            }
          }
        ]
      end

      let!(:author) { create(:user, firstname: 'john', lastname: 'doe', id: 7) }
      let!(:category) { create(:category, name: 'blogs') }
      let!(:posts_categories) { create(
        :posts_category,
        post_id: post.id,
        category_id: category.id
      ) }
      let!(:post) { create(
        :post,
        title: 'my title',
        content: 'my content',
        user_id: author.id
      ) }


      it ('gives me back Json for all posts') do
        get :index, format: :json
        expect(response.body).to match_json_expression(payload)
      end

      it ('gives me back Json for one post') do
        get :show, format: :json, id: 1
        expect(response.body).to match_json_expression(payload[0])
      end
    end

    context 'when there are no posts' do
      it 'returns an empty collection' do
        get :index
        expect(assigns(:post)).to eq([])
        expect(assigns(:total_pages)).to eq(0)
      end
    end

    context 'when there are less posts than the per_page' do
      let!(:post_1) { create(:post, created_at: 1.day.ago) }
      let!(:post_2) { create(:post) }
      it 'returns all available posts' do
        get :index
        expect(assigns(:post)).to eq([post_2, post_1])
        expect(assigns(:total_pages)).to eq(1)
      end
    end

    context 'when there is an amount equal to the per_page' do
      let!(:post_1) { create(:post, created_at: 4.days.ago) }
      let!(:post_2) { create(:post, created_at: 3.days.ago) }
      let!(:post_3) { create(:post, created_at: 2.days.ago) }
      let!(:post_4) { create(:post, created_at: 1.day.ago) }
      let!(:post_5) { create(:post) }
      it 'returns all the records in the collection' do
        get :index
        expect(assigns(:post)).to eq([
          post_5,
          post_4,
          post_3,
          post_2,
          post_1
        ])
        expect(assigns(:total_pages)).to eq(1)
      end
    end

    context 'when it is 2nd page' do
      let!(:post_1) { create(:post, created_at: 9.day.ago) }
      let!(:post_2) { create(:post, created_at: 8.day.ago) }
      let!(:post_3) { create(:post, created_at: 7.day.ago) }
      let!(:post_4) { create(:post, created_at: 6.day.ago) }
      let!(:post_5) { create(:post, created_at: 5.day.ago) }
      let!(:post_6) { create(:post, created_at: 4.day.ago) }
      let!(:post_7) { create(:post, created_at: 3.day.ago) }
      let!(:post_8) { create(:post, created_at: 2.day.ago) }
      let!(:post_9) { create(:post, created_at: 1.day.ago) }
      let!(:post_10) { create(:post) }
      it 'returns the posts 5 posts from the 5 oldest to 10th oldest' do
        get :index, { :page => '2' }
        expect(assigns(:post)).to eq([
          post_5,
          post_4,
          post_3,
          post_2,
          post_1
        ])
        expect(assigns(:total_pages)).to eq(2)
      end
    end

    context 'when page param is negative' do
      let!(:post_1) { create(:post) }
      it 'returns the default first page' do
        get :index, { :page => '-2' }
        expect(assigns(:post)).to eq([post_1])
        expect(assigns(:total_pages)).to eq(1)
      end
    end

    context 'when per_page param is different from default 5' do
      let!(:post_1) { create(:post, created_at: 4.days.ago) }
      let!(:post_2) { create(:post, created_at: 3.days.ago) }
      let!(:post_3) { create(:post, created_at: 2.days.ago) }
      let!(:post_4) { create(:post, created_at: 1.day.ago) }
      let!(:post_5) { create(:post) }
      it 'returned posts count matches the per_page number' do
        get :index, { :per_page => '3' }
        expect(assigns(:post)).to eq([post_5, post_4, post_3])
        expect(assigns(:total_pages)).to eq(2)
      end
    end
  end

  describe '#update' do
    let!(:post) { create(:post) }
    let!(:user) { create(:user) }
    let!(:valid_params) do
      {
        post: { title: 'updated title', content: 'updated content' }
      }
    end

    context 'when post is successfully updated' do
      it 'renders the show page for the updated post' do
        put :update, valid_params, { user_id: user.id }

        expect(response).to render_template(:show)
      end
    end

    # context 'when post fails to updated' do
    #   it 'renders the edit page for that post' do
    #     post :update, id: post.id
    #
    #     expect(response).to render_template(:show)
    #   end
    # end
  end
end
