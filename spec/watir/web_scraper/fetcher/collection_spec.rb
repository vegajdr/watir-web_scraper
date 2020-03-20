# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Fetcher::Collection do
  subject(:fetcher_collection) { described_class.new(fetchers) }

  describe '#fetched_data' do
    subject(:fetched_data) { fetcher_collection.fetched_data }

    let(:first_fetcher) { instance_double(Watir::WebScraper::Fetcher) }
    let(:second_fetcher) { instance_double(Watir::WebScraper::Fetcher) }

    let(:fetchers) do
      [
        first_fetcher,
        second_fetcher
      ]
    end

    let(:expected_data) do
      {
        foo: :bar,
        baz: :qux
      }
    end

    before do
      allow(first_fetcher).to receive(:fetched_data).and_return(foo: :bar)
      allow(second_fetcher).to receive(:fetched_data).and_return(baz: :qux)
    end

    it { is_expected.to eq(expected_data) }
  end
end
