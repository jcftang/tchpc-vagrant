module Puppet::Parser::Functions
  newfunction(:default_value, :type => :rvalue) do |args|
    unless args.length == 2
      raise Puppet::ParseError, "default_value requires 2 arguments"
    end
    # We want to test for an unset variable in the DSL, but an unset variable
    # becomes an empty string by the time it percolates down to this function.
    # Check for emptiness, even though this means we cannot set an explicit
    # empty string or array for an optional variable that uses this function.
    args[0].empty? ? args[1] : args[0]
  end
end
