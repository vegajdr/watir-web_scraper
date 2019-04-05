# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Scraper do
  subject(:scraper) { described_class.new(args) }

  let(:args) do
    {
      actions: actions,
      params: params
    }
  end

  let(:actions) { [step_class, path_class, fetch_class] }

  let(:step_class) { class_double(Watir::WebScraper::Step) }
  let(:step_instance) { instance_double(Watir::WebScraper::Step) }

  let(:path_class) { class_double(Watir::WebScraper::Path) }
  let(:path_instance) { instance_double(Watir::WebScraper::Path) }

  let(:fetch_class) { class_double(Watir::WebScraper::Fetcher) }
  let(:fetch_instance) { instance_double(Watir::WebScraper::Fetcher) }

  let(:params) { {} }

  describe '#perform' do
    before do
      [:step, :path, :fetch].each do |action|
        allow(send("#{action}_class".to_sym)).to receive(:new).and_return(send("#{action}_instance".to_sym))
        allow(send("#{action}_instance".to_sym)).to receive(:start)
      end
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

    it { is_expected.to eq(actions) }
  end
end
