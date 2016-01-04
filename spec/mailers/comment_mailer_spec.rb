require 'rails_helper'

describe CommentMailer do
  let(:comment) { build(:comment) }

  context '#email' do
    subject { described_class.email(comment) }

    its(:from) { is_expected.to include(comment.user_email) }
    its(:to) { is_expected.to include('krystianczesak+rubik-ets@gmail.com') }
  end
end
