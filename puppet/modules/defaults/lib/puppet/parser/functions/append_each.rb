module Puppet::Parser::Functions
  newfunction(:append_each, :type => :rvalue) do |args|
    unless args.length == 2
      raise Puppet::ParseError, "append_each requires 2 arguments"
    end
    args[0].collect { |x| x + args[1] }
  end
end
