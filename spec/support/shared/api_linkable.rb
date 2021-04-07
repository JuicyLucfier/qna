shared_examples_for 'API Linkable' do
  describe 'links' do
    let!(:links) { create_list(:link, 2, linkable: linkable) }

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it "returns links" do
      expect(linkable_response['links'].size).to eq linkable.send('links').size
    end
  end
end
