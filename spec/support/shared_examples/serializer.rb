# frozen_string_literal: true

shared_examples "Serializer" do |data_structure:, as_json:|
  describe ".dump" do
    it "dumps the data structure to JSON" do
      expect(described_class.dump(data_structure)).to eq(as_json.to_json)
    end
  end

  describe ".load" do
    context "when a nil value is passed" do
      it "returns an empty array" do
        expect(described_class.load(nil)).to eq([])
      end
    end

    context "when a valid payload is passed" do
      it "returns the appropriate data structure" do
        expect(described_class.load(as_json.to_json)).to eq(data_structure)
      end
    end
  end

  describe ".dump_as_json" do
    it "dumps the data structure as JSON" do
      expect(described_class.dump_as_json(data_structure)).to eq(as_json)
    end
  end

  describe ".load_as_json" do
    it "loads the appropriate data structure" do
      expect(described_class.load_as_json(as_json)).to eq(data_structure)
    end
  end
end
