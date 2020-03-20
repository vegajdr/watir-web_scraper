# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Path do
  subject(:path) { described_class.new(browser, params, fetched_data) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:params) { instance_double(Hash) }
  let(:fetched_data) { instance_double(Hash) }

  it { is_expected.not_to be_a_fetcher }

  describe '#call' do
    subject(:call) { path.call }

    it { expect { call }.to raise_error(NameError) }

    context 'when STEPS constant is defined in subclass' do
      let(:path) { TestPath.new(browser, params, fetched_data) }
      let(:step) { class_double(Watir::WebScraper::Step) }
      let(:step_instance) { instance_double(Watir::WebScraper::Step) }
      let(:steps) do
        [step]
      end

      before do
        stub_const 'TestPath', Class.new(described_class)
        stub_const 'TestPath::STEPS', steps

        allow(step).to receive(:new).and_return(step_instance)
        allow(step_instance).to receive(:start)

        call
      end

      it { expect(step_instance).to have_received(:start) }
    end
  end
end
