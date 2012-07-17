module Puppet::Parser::Functions
  newfunction(:concat, :type => :rvalue) do |args|
    result = []
    args.each { |x| result.concat([x]) }
    result.flatten
  end
end
