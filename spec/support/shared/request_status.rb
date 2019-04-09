shared_examples_for 'Request status' do
  it 'return 200' do
    expect(response).to be_successful
  end
end
