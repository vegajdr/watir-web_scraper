# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Scraper do
  subject(:scraper) { described_class.new(args) }

  let(:args) do
    {
      actions: actions,
      params: params
    }
  end

  let(:actions) { [login_class, submit_class, fetch_class, logout_class] }

  let(:browser_class) { class_double(Watir::WebScraper::ChromeBrowser) }
  let(:browser_instance) { instance_double(Watir::WebScraper::ChromeBrowser) }

  let(:login_class) { class_double(Watir::WebScraper::Page::Step::Base) }
  let(:login_instance) { instance_double(Watir::WebScraper::Page::Step::Base) }

  let(:submit_class) do
    class_double(Watir::WebScraper::Page::Step::Base)
  end
  let(:submit_instance) do
    instance_double(Watir::WebScraper::Page::Step::Base)
  end

  let(:fetch_class) { class_double(Watir::WebScraper::Page::Fetcher::Base) }
  let(:fetch_instance) { instance_double(Watir::WebScraper::Page::Fetcher::Base) }

  let(:logout_class) { class_double(Watir::WebScraper::Page::Step::Base) }
  let(:logout_instance) { instance_double(Watir::WebScraper::Page::Step::Base) }

  let(:params) { {} }

  describe '#perform' do
    before do
      [:login, :submit, :fetch, :logout].each do |action|
        allow(send("#{action}_class".to_sym)).to receive(:new).and_return(send("#{action}_instance".to_sym))
        allow(send("#{action}_instance".to_sym)).to receive(:start)
      end

      allow(browser_instance).to receive(:exists?).with(no_args).and_return(true)
      allow(browser_instance).to receive(:close).with(no_args).and_return(true)
    end

    context 'when routine is successful' do
      it { expect(scraper.perform).to eq(true) }
    end

    describe 'errors' do
      context 'when routine encounters rescuable error' do
        let(:rescuable_error) { Selenium::WebDriver::Error::WebDriverError }

        before { allow(submit_instance).to receive(:start).and_raise(rescuable_error) }

        it { expect(scraper.perform).to eq(false) }

        describe 'adds error message from exception' do
          before { scraper.perform }

          it { expect(scraper.errors).to be_present }
          it { expect(scraper.errors.first[:message]).to eq(rescuable_error.new.message) }
        end
      end

      context 'when routine encounters non rescuable error' do
        before { allow(submit_instance).to receive(:start).and_raise(StandardError) }

        it { expect { scraper.perform }.to raise_error(StandardError) }
      end

      context 'when error is retryable' do
        let(:retryable_error) { Watir::Wait::TimeoutError }

        before { allow(submit_instance).to receive(:start).and_raise(retryable_error) }

        it { expect { scraper.perform }.to change { scraper.errors.count }.by 2 }
      end

      context 'when error is not retryable' do
        let(:non_retryable_error) { Watir::WebScraper::Scraper::Error }

        before { allow(submit_instance).to receive(:start).and_raise(non_retryable_error) }

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
