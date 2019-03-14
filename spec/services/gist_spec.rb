require 'rails_helper'

describe 'Gist service' do
  let(:url) { 'https://gist.github.com/romka69/54370693ce6554b1afceaf0ef0076d36' }
  let(:url2) { 'https://gist.github.com/romka69/00000000000000000000000000000000' }

  it 'valid url' do
    expect(GistService.new(url).content).to eq 'Simple text'
  end

  it 'non valid url' do
    expect(GistService.new(url2).content).to eq 'Not found content in gist'
  end
end
