# frozen_string_literal: true

require "rails_helper"

describe CommentMailer do
  let(:comment) { build(:comment) }

  describe "#email" do
    subject { described_class.email(comment) }

    its(:from) { is_expected.to include(comment.user_email) }
    its(:to) { is_expected.to include("email@local.com") }
  end
end
