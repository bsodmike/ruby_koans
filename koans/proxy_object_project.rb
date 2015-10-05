# Project: Create a Proxy Class
#
# In this assignment, create a proxy class (one is started for you
# below).  You should be able to initialize the proxy object with any
# object.  Any messages sent to the proxy object should be forwarded
# to the target object.  As each message is sent, the proxy should
# record the name of the method sent.
#
# The proxy class is started for you.  You will need to add a method
# missing handler and any other supporting methods.  The specification
# of the Proxy class is given in the AboutProxyObjectProject koan.

class Proxy

  def initialize(target_object)
    @object = target_object
    @messages = []
  end

  attr_accessor :messages

  def called?(method)
    !!(messages.include?(method))
  end

  def number_of_times_called(method)
    counts = Hash.new(0)
    messages.each { |x| counts[x] += 1 }

    counts[method]
  end

  private
  def method_missing(*args, &block)
    if self.respond_to?(*args)
      self.send(*args, &block)
    else
      args.each { |arg| messages << arg if arg.is_a?(Symbol) }
      @object.send(*args, &block)
    end
  end

end
