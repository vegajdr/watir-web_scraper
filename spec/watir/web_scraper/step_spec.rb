# frozen_string_literal: true

RSpec.describe Watir::WebScraper::Step do
  subject(:step) { described_class.new(browser, params, fetched_data) }

  let(:browser) { instance_double(Watir::Browser) }
  let(:params) { instance_double(Hash) }
  let(:fetched_data) { instance_double(Hash) }

  it { is_expected.not_to be_a_fetcher }

  describe '#call' do
    subject(:call) { step.call }

    it { expect { call }.to raise_error(NotImplementedError) }

    context 'when #instructions is implemented in subclass' do
      let(:step) { TestStep.new(browser, params, fetched_data) }

      before do
        stub_const 'TestStep', Class.new(described_class)

        allow(step).to receive(:instructions)

        call
      end

      it { expect(step).to have_received(:instructions) }
    end
  end
end
