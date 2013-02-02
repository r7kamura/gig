require "spec_helper"

describe EntriesController do
  before do
    User.any_instance.stub(:github_client => github_client)
  end

  def login
    controller.stub(:current_user => current_user)
  end

  let(:github_client) do
    mock(
      :list => [
        {
          :path      => "entries/name.md",
          :persisted => true,
        }
      ],
      :find => {
        :content   => "content",
        :path      => "entries/name.md",
        :persisted => true,
      }
    )
  end

  let(:current_user) do
    FactoryGirl.create(:user)
  end

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:entry) do
    Entry.new(
      :content   => "content",
      :path      => "entries/name.md",
      :persisted => true
    )
  end

  describe "#show" do
    subject do
      get :show, :user_id => user.nickname, :id => entry.filename
    end

    it { should be_ok }
  end

  describe "#new" do
    subject do
      get :new, :user_id => user.nickname
    end

    before do
      login
    end

    it { should be_ok }
  end

  describe "#create" do
    subject do
      post :create, :user_id => user.nickname, :entry => { :name => "name", :content => "content" }
    end

    before do
      login
    end

    it "creates a new entry" do
      github_client.should_receive(:update).with("entries/name.md", "content")
      should redirect_to [current_user, entry]
    end
  end

  describe "#new" do
    subject do
      get :new, :user_id => user.nickname
    end

    before do
      login
    end

    it { should be_ok }
  end

  describe "#edit" do
    subject do
      get :edit, :user_id => user.nickname, :id => entry.id
    end

    before do
      login
    end

    it { should be_ok }
  end

  describe "#update" do
    subject do
      put :update, :user_id => user.nickname, :id => entry.id, :entry => { :name => "name", :content => "content" }
    end

    before do
      login
    end

    it "updates the found entry" do
      github_client.should_receive(:update).with("entries/name.md", "content")
      should redirect_to [current_user, entry]
    end
  end

  describe "#destroy" do
    subject do
      delete :destroy, :user_id => user.nickname, :id => entry.id
    end

    before do
      login
    end

    it "destroys an entry and redirects to entries path" do
      github_client.should_receive(:delete).with("entries/name.md")
      should redirect_to current_user
    end
  end
end
