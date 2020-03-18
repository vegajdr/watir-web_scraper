# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Fetcher do
  subject(:fetcher) { described_class.new(browser, params) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:params) { instance_double(Hash) }

  describe '#call' do
    subject(:call) { fetcher.call }

    it { expect { call }.to raise_error(NotImplementedError) }

    context 'when #fetch is implemented in subclass' do
      let(:fetcher) { TestFetcher.new(browser, params) }

      before do
        stub_const 'TestFetcher', Class.new(described_class)

        allow(fetcher).to receive(:fetch)

        call
      end

      it { expect(fetcher).to have_received(:fetch) }
    end
  end
end
