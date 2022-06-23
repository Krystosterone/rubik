# frozen_string_literal: true

require "rails_helper"

describe User do
  it { is_expected.to allow_value("test@domain.com").for(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }

  describe ".subscribed_to_newsletter" do
    let(:users) { create_list(:user, 3) }

    it "returns users subscribed to the newsletter" do
      expect(described_class.subscribed_to_newsletter).to eq(users)
    end
  end

  describe "#save" do
    subject(:user) { build(:user) }

    it "subscribes it to the newsletter" do
      expect { user.save! }.to change(described_class, :subscribed_to_newsletter).from([]).to([user])
    end
  end
end
