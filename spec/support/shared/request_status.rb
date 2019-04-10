shared_examples_for 'Request status success' do
  it 'return success' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Request status 201' do
  it 'return 201' do
    expect(response.status).to eq 201
  end
end
