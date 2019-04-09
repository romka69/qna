shared_examples_for 'Returns list of' do
  it 'resource' do
    expect(json_resource.size).to eq 2
  end
end
