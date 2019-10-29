require 'rails_helper'

describe Post do
  describe '#calculate_slug' do
    let(:post) { Post.new(title: title) }

    context '1 when title is a single word' do
      let(:title) { 'title' }

      it "returns the title" do
        expect(post.calculate_slug).to eq('title')
      end
    end

    context '2 when title is uppercase' do
      let(:title) { 'TITLE' }

      it "returns as lowercase" do
        expect(post.calculate_slug).to eq('title')
      end
    end

    context '3 when title has empty spaces' do
      let(:title) { 'string title' }

      it "replaces spaces with _" do
        expect(post.calculate_slug).to eq('string_title')
      end
    end

    context '4 when title has periods' do
      let(:title) { 'string. title' }

      it "removes ." do
        expect(post.calculate_slug).to eq('string_title')
      end
    end

    context '5 when title has : and space next to each other' do
      let(:title) { 'string: title' }

      it "removes replaces both and shortens to 1 _" do
        expect(post.calculate_slug).to eq('string_title')
      end
    end

    context '6 when title has -' do
      let(:title) { 'string-title' }

      it "removes -" do
        expect(post.calculate_slug).to eq('string_title')
      end
    end

    context '7 when title has capitals' do
      let(:title) { 'StrinG CaPitalIzeD' }

      it "downcase the entire title" do
        expect(post.calculate_slug).to eq('string_capitalized')
      end
    end

    context '8 when title has weird characters' do
      let(:title) { 'title@?$%&^*!' }

      it "removes :" do
        expect(post.calculate_slug).to eq('title')
      end
    end

    context '8 when title has replaceable char at beginning or end' do
      let(:title) { ' title. ' }

      it "removes :" do
        expect(post.calculate_slug).to eq('title')
      end
    end
  end
end
