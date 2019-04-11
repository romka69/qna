shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 if there is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end

    it 'return 401 if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)

      expect(response.status).to eq 401
    end
  end
end

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

shared_examples_for 'Returns fields' do
  it 'all public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource_name.send(attr).as_json
    end
  end
end

shared_examples_for 'Returns list of' do
  it 'resource' do
    expect(json_resource.size).to eq 2
  end
end
