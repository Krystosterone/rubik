# frozen_string_literal: true

require "rails_helper"

describe TermsController do
  let!(:terms) { create_list(:term, 3) }

  describe "#index" do
    before { get :index }
    let(:newsletter_subscription) { assigns(:newsletter_subscription) }

    it "assigns the terms" do
      expect(assigns(:terms)).to eq(terms.reverse)
    end

    it "assigns a new newsletter subscription" do
      expect(newsletter_subscription).to be_instance_of(NewsletterSubscription)
    end

    specify { expect(newsletter_subscription).to be_new_record }

    it "renders the index" do
      expect(response).to render_template(:index)
    end
  end

  describe "#create_newsletter_subscription" do
    context "when the newsletter subscription did not succeed" do
      before { post :create_newsletter_subscription, params: { newsletter_subscription: { email: "nope" } } }
      let(:newsletter_subscription) { assigns(:newsletter_subscription) }

      it "assigns the terms" do
        expect(assigns(:terms)).to eq(terms.reverse)
      end

      it "assigns a new newsletter subscription" do
        expect(newsletter_subscription).to be_a_new(NewsletterSubscription)
      end

      specify { expect(newsletter_subscription.email).to eq("nope") }

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    context "when the newsletter subscription did succeed" do
      before { post :create_newsletter_subscription, params: { newsletter_subscription: { email: "1@b.ca" } } }
      let(:newsletter_subscription) { NewsletterSubscription.last }

      it "assigns a new newsletter subscription" do
        expect(newsletter_subscription.email).to eq("1@b.ca")
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
