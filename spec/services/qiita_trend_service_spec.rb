require 'rails_helper'

RSpec.describe QiitaTrendService do
  describe '.fetch_trends' do
    let(:items) do
      [
        {
          'title' => 'RSpec書いてみた',
          'url' => 'https://qiita.com/test1',
          'user' => { 'id' => 'user1' },
          'likes_count' => 25
        },
        {
          'title' => 'Qiitaのサービス作ってみた',
          'url' => 'https://qiita.com/test2',
          'user' => { 'id' => 'user2' },
          'likes_count' => 30
        }
      ]
    end

    context 'API呼び出しに成功' do
      before do
        allow(QiitaApiClient).to receive(:get).and_return(items)
      end

      it 'フォーマットされた記事が返される' do
        result = QiitaTrendService.fetch_trends
        expect(result.length).to eq(2)
        expect(result.first).to include(
          title: 'RSpec書いてみた',
          url: 'https://qiita.com/test1',
          user: 'user1',
          likes: 25
        )
      end
    end
  end
end
