shared_examples_for 'API Commentable' do
  describe 'comments' do
    let!(:comments) { create_list(:comment, 2, commentable: commentable, author: user) }
    let(:comment) { commentable.comments.first }
    let(:comment_response) { commentable_response['comments'].first }

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it 'returns list of comments' do
      expect(commentable_response['comments'].size).to eq commentable.comments.size
    end

    it 'returns all public fields' do
      %w[id body created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
