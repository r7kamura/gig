require "spec_helper"

describe ApplicationController do
  describe "#current_user" do
    subject { controller.send(:current_user) }

    let(:user) do
      FactoryGirl.create(:user)
    end

    context "with no user id in session" do
      it { should be_nil }
    end

    context "with correct user id in session" do
      before do
        session[:user_id] = user.id
      end
      it { should == user }
    end

    context "with wrong user id in session" do
      before do
        session[:user_id] = 0
      end
      it "returns nil and removes the session id" do
        user
        should be_nil
        session[:user_id].should be_nil
      end
    end
  end
end
