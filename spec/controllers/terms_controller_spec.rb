# frozen_string_literal: true

require "rails_helper"

describe TermsController do
  let!(:terms) { create_list(:term, 3) }

  describe "#index" do
    before { get :index }

    let(:user) { assigns(:user) }

    it "assigns the terms" do
      expect(assigns(:terms)).to eq(terms.reverse)
    end

    it "assigns a new user" do
      expect(user).to be_instance_of(User)
    end

    specify { expect(user).to be_new_record }

    it "renders the index" do
      expect(response).to render_template(:index)
    end
  end

  describe "#create_newsletter_subscription" do
    context "when the newsletter subscription did not succeed" do
      before { post :create_newsletter_subscription, params: { user: { email: "nope" } } }

      let(:user) { assigns(:user) }

      it "assigns the terms" do
        expect(assigns(:terms)).to eq(terms.reverse)
      end

      it "assigns a new user" do
        expect(user).to be_a_new(User)
      end

      specify { expect(user.email).to eq("nope") }

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    context "when the newsletter subscription did succeed" do
      before { post :create_newsletter_subscription, params: { user: { email: "1@b.ca" } } }

      let(:user) { User.last }

      it "assigns a new user" do
        expect(user.email).to eq("1@b.ca")
      end

      it "redirects to the root" do
        expect(response).to redirect_to(root_path)
      end

      it "renders a flash notice" do
        expect(flash[:notice]).to eq(I18n.t("terms.create_newsletter_subscription.success"))
      end
    end
  end
end
