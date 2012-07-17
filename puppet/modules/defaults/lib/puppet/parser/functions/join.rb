module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue) do |args|
    unless args.length == 2
      raise Puppet::ParseError, "join requires 2 arguments"
    end
    args[0] = [args[0]] unless args[0].is_a?(Array)
    args[0].join(args[1])
  end
end
