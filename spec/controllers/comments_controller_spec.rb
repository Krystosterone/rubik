# frozen_string_literal: true

require "rails_helper"

describe CommentsController do
  let(:comment) { assigns(:comment) }

  describe "#new" do
    before { get :new }

    it { is_expected.to render_template(:new) }

    it "assigns a new comment" do
      expect(comment).to be_a_new(Comment)
    end
  end

  describe "#create" do
    context "when there is a missing parameter" do
      it "raises an exception" do
        expect { post :create }.to raise_exception(ActionController::ParameterMissing)
      end
    end

    context "when the comment cannot be saved" do
      before do
        allow_any_instance_of(Comment).to receive(:save).and_return(false)
        post :create, params: {
          comment: {
            user_email: "some_email",
            body: "text body"
          }
        }
      end

      it { is_expected.to render_template(:new) }

      it "assigns the new comment" do
        expect(comment).to be_a_new(Comment)
      end

      it "assigns the new comment with correct attributes" do
        expect(comment.slice(:user_email, :body)).to eq(
          "user_email" => "some_email",
          "body" => "text body"
        )
      end
    end

    context "when the comment was able to be saved" do
      let(:comment) { Comment.last }

      before do
        post :create, params: {
          comment: {
            user_email: "email@domain.com",
            body: "Some comment"
          }
        }
      end

      it { is_expected.to redirect_to(new_comment_path) }

      it "renders a flash notice" do
        expect(flash[:notice]).to eq(I18n.t("comments.create.success"))
      end

      it "created the comment" do
        expect(comment.slice(:user_email, :body)).to eq(
          "user_email" => "email@domain.com",
          "body" => "Some comment"
        )
      end
    end
  end
end
