# frozen_string_literal: true

require "rails_helper"

describe Comment do
  it { is_expected.to allow_value("test@domain.com").for(:user_email) }
  it { is_expected.to validate_presence_of(:body) }

  describe "#save!" do
    context "with an after commit hook" do
      let(:comment_mailer) { instance_double(ActionMailer::MessageDelivery) }
      let(:comment) { build(:comment) }

      before { allow(CommentMailer).to receive(:email).with(comment).and_return(comment_mailer) }

      it "delivers an email" do
        allow(comment_mailer).to receive(:deliver_later)

        comment.save!
      end
    end
  end
end
