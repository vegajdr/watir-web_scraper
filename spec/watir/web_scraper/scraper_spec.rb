# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Scraper do
  subject(:scraper) { described_class.new(args) }

  let(:args) do
    {
      actions: actions,
      params: params,
      browser: browser
    }
  end

  let(:browser) { class_double(Watir::WebScraper::Browser::Chrome) }

  let(:params) { {} }

  before do
    allow(browser).to receive(:start)
    allow(browser).to receive(:new)
  end

  describe '#perform' do
    let(:actions) { [step_class, path_class, fetcher_class] }

    let(:step_class) { class_double(Watir::WebScraper::Step) }
    let(:step_instance) { instance_double(Watir::WebScraper::Step) }

    let(:path_class) { class_double(Watir::WebScraper::Path) }
    let(:path_instance) { instance_double(Watir::WebScraper::Path) }

    let(:fetcher_class) { class_double(Watir::WebScraper::Fetcher) }
    let(:fetcher_instance) { instance_double(Watir::WebScraper::Fetcher) }

    before do
      allow(step_class).to receive(:new).and_return(step_instance)
      allow(step_instance).to receive(:start)
      allow(step_instance).to receive(:fetcher?).and_return(false)

      allow(path_class).to receive(:new).and_return(path_instance)
      allow(path_instance).to receive(:start)
      allow(path_instance).to receive(:fetcher?).and_return(false)

      allow(fetcher_class).to receive(:new).and_return(fetcher_instance)
      allow(fetcher_instance).to receive(:start)
      allow(fetcher_instance).to receive(:fetcher?).and_return(true)
    end

    context 'when routine is successful' do
      it { expect(scraper.perform).to eq(true) }
    end

    describe 'errors' do
      context 'when routine encounters rescuable error' do
        let(:rescuable_error) { Selenium::WebDriver::Error::WebDriverError }

        before { allow(path_instance).to receive(:start).and_raise(rescuable_error) }

        it { expect(scraper.perform).to eq(false) }

        describe 'adds error message from exception' do
          before { scraper.perform }

          it { expect(scraper.errors).to be_present }
          it { expect(scraper.errors.first[:message]).to eq(rescuable_error.new.message) }
        end
      end

      context 'when routine encounters non rescuable error' do
        before { allow(path_instance).to receive(:start).and_raise(StandardError) }

        it { expect { scraper.perform }.to raise_error(StandardError) }
      end

      context 'when error is retryable' do
        let(:retryable_error) { Watir::Wait::TimeoutError }

        before { allow(path_instance).to receive(:start).and_raise(retryable_error) }

        it { expect { scraper.perform }.to change { scraper.errors.count }.by 2 }
      end

      context 'when error is not retryable' do
        let(:non_retryable_error) { Watir::WebScraper::Scraper::Error }

        before { allow(path_instance).to receive(:start).and_raise(non_retryable_error) }

        it { expect { scraper.perform }.to change { scraper.errors.count }.by 1 }
      end
    end

    describe 'adds attempt count' do
      it { expect { scraper.perform }.to change(scraper, :attempts).by(1) }
    end
  end

  describe '#actions' do
    subject { scraper.actions }

    let(:actions) { [step_class] }
    let(:step_class) { class_double(Watir::WebScraper::Step) }

    it { is_expected.to eq(actions) }
  end

  describe '#fetched_data' do
    subject(:fetched_data) { scraper.fetched_data }

    let(:actions) { [] }

    it { is_expected.to be_a(Hash) }

    context 'when fetcher action exists during perform routine' do
      let(:actions) { [fetcher_class] }

      let(:fetcher_class) { class_double(Watir::WebScraper::Fetcher) }
      let(:fetcher) { instance_double(Watir::WebScraper::Fetcher) }
      let(:test_data) { { test: :data } }

      before do
        allow(fetcher_class).to receive(:new).and_return(fetcher)
        allow(fetcher).to receive(:fetcher?).and_return(true)
        allow(fetcher).to receive(:start).and_return(fetcher)
        allow(fetcher).to receive(:fetched_data).and_return(test_data)

        scraper.perform
      end

      it 'returns data fetched by fetcher' do
        expect(fetched_data).to eq(test_data)
      end
    end

    context 'when multiple fetcher actions exist during perform routine' do
      let(:actions) { [first_fetcher_class, second_fetcher_class] }

      let(:first_fetcher_class) { class_double(Watir::WebScraper::Fetcher) }
      let(:second_fetcher_class) { class_double(Watir::WebScraper::Fetcher) }

      let(:first_fetcher) { instance_double(Watir::WebScraper::Fetcher) }
      let(:second_fetcher) { instance_double(Watir::WebScraper::Fetcher) }

      let(:expected_data) do
        {
          foo: :bar,
          baz: :qux
        }
      end

      before do
        allow(first_fetcher_class).to receive(:new).and_return(first_fetcher)
        allow(second_fetcher_class).to receive(:new).and_return(second_fetcher)

        allow(first_fetcher).to receive(:start).and_return(first_fetcher)
        allow(second_fetcher).to receive(:start).and_return(second_fetcher)

        allow(first_fetcher).to receive(:fetcher?).and_return(true)
        allow(second_fetcher).to receive(:fetcher?).and_return(true)

        allow(first_fetcher).to receive(:fetched_data).and_return(foo: :bar)
        allow(second_fetcher).to receive(:fetched_data).and_return(baz: :qux)

        scraper.perform
      end

      it 'returns merged data fetched by all fetchers' do
        expect(fetched_data).to eq(expected_data)
      end
    end
  end
end
