RSpec.shared_examples 'votable' do |obj|
  let(:user) { create :user }
  let!(:user2) { create :user }
  let!(:user3) { create :user }
  let!(:user4) { create :user }
  let(:model) { create(obj, author: user) }

  before do
    if :model.is_a?(Answer)
      let(:question) { create :question, author: user }
      let!(:model) { create(obj, author: user, question: question) }
    end
  end

  it '#vote_up' do
    model.vote_up(user2)
    model.reload

    expect(model.score_resource).to eq 1
  end

  it '#vote_up as author' do
    model.vote_up(user)
    model.reload

    expect(model.score_resource).to_not eq 1
  end

  it '#vote_down' do
    model.vote_down(user2)
    model.reload

    expect(model.score_resource).to eq -1
  end

  it '#vote_down as author' do
    model.vote_down(user)
    model.reload

    expect(model.score_resource).to_not eq -1
  end

  it '#score_resource' do
    model.vote_up(user2)
    model.vote_up(user2)
    model.vote_down(user2)
    model.vote_up(user3)
    model.vote_up(user4)
    model.reload

    expect(model.score_resource).to eq 2
  end
end
