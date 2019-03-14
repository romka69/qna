require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'Check gist url' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:link) { create :link, linkable: question }
    let(:link2) { create :link, :invalid, linkable: question }

    it 'gist url?' do
      expect(link).to be_gist_url
    end

    it 'not gist url?' do
      expect(link2).to_not be_gist_url
    end
  end
end
