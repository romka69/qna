require 'rails_helper'

RSpec.shared_examples 'votable' do |obj|
  let(:user) { create :user }
  let(:model) { create(obj, author: user) }

  it '#vote_up' do
    model.vote_up(user)
    model.reload

    expect(model.score_resource).to eq 1
  end

  it '#vote_down' do
    model.vote_down(user)
    model.reload

    expect(model.score_resource).to eq -1
  end

  it '#score_resource' do
    model.vote_up(user)
    model.vote_up(user)
    model.vote_down(user)
    model.vote_up(user)
    model.reload

    expect(model.score_resource).to eq 1
  end
end
