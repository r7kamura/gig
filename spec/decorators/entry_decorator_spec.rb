require "spec_helper"

describe EntryDecorator do
  let(:instance) do
    described_class.new(entry)
  end

  let(:entry) do
    Entry.new(
      :content  => "# title",
      :nickname => "test",
      :path     => "entries/title.md",
      :time     => Time.utc(2000, 1, 1)
    )
  end

  describe "#title" do
    it "humanizes its basename" do
      instance.title.should == "Title"
    end
  end

  describe "#date" do
    it "returns a date of its time" do
      instance.date.should == Date.new(2000, 1, 1)
    end
  end

  describe "#edit_path" do
    it "returns a path to edit entry" do
      instance.edit_path.should == "/test/title.md/edit"
    end
  end

  describe "#github_path" do
    it "returns a path to show entry on github" do
      instance.github_path.should == "https://github.com/test/gigdb/tree/master/entries/title.md"
    end
  end

  describe "#filename" do
    it "returns its basename with ext" do
      instance.filename.should == "title.md"
    end
  end

  describe "#rendered_content" do
    it "returns a content rendered as Markdown format" do
      instance.rendered_content.should == "<h1>title</h1>\n"
    end
  end
end
