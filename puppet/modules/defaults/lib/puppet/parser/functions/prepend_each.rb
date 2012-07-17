module Puppet::Parser::Functions
  newfunction(:prepend_each, :type => :rvalue) do |args|
    unless args.length == 2
      raise Puppet::ParseError, "prepend_each requires 2 arguments"
    end
    args[0].collect { |x| args[1] + x }
  end
end
