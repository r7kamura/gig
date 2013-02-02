module EntriesHelper
  def decorate(args)
    case args
    when Enumerable
      args.map {|e| EntryDecorator.new(e) }
    else
      EntryDecorator.new(args)
    end
  end
end
