require "rails_helper"

describe EtsPdf::Etl::Transform do
  it_behaves_like "Pipeline"

  describe '#execute' do
    let(:terms) { { 2016 => :arguments, 2015 => :more_arguments } }
    subject { described_class.new(terms) }

    it "updates the database for every term passed in" do
      terms.each do |arguments|
        term_updater = double(EtsPdf::Etl::Transform::TermUpdater)
        expect(term_updater).to receive(:execute)

        allow(EtsPdf::Etl::Transform::TermUpdater)
          .to receive(:new).with(*arguments).and_return(term_updater)
      end

      subject.execute
    end
  end
end
