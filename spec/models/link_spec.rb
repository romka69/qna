require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'Check gist' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:link) { create :link, linkable: question }

    let(:link2) { create :link, :invalid_gist, linkable: question }

    it 'url?' do
      expect(link).to be_gist_url
    end

    it 'not gist url?' do
      expect(link2).to_not be_gist_url
    end

    it 'content - ok' do
      expect(link.gist(link.url)).to eq 'Simple text'
    end

    it 'content - fails' do
      expect(link2.gist(link2.url)).to eq 'Not found content in gist'
    end
  end
end
