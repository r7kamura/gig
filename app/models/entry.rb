class Entry
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_reader :attributes

  def self.new_with_name(attributes)
    if attributes[:name]
      attributes[:path] = "#{attributes.delete(:name)}.md"
    end
    new(attributes)
  end

  def initialize(attributes = {})
    @attributes = attributes
  end

  def save
    if valid?
      user.commit(self)
      user.clear_cache(self)
      persisted!
      self
    else
      false
    end
  end

  def valid?
    name.present?
  end

  def id
    filename
  end

  def content
    @attributes[:content]
  end

  def path
    @attributes[:path]
  end

  def persisted?
    @attributes[:persisted]
  end

  def time
    @attributes[:time]
  end

  def nickname
    @attributes[:nickname]
  end

  def persisted!
    @attributes[:persisted] = true
  end

  def pathname
    @pathname ||= Pathname.new(path || "")
  end

  def filename
    pathname.basename.to_s
  end

  def name
    pathname.basename(".*").to_s.gsub(/^\..*/, "")
  end

  def title
    name
  end

  def date
    time.localtime.to_date
  end

  def user
    @user ||= User.find_by_nickname!(nickname)
  end

  def to_param
    filename
  end
end
