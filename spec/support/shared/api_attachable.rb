shared_examples_for 'API Attachable' do
  describe 'files' do
    before {
      attachable.files.attach(io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb')
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    }

    it "returns files" do
      expect(attachable_response['files'].size).to eq attachable.send('files').size
    end
  end
end
