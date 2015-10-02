require File.expand_path(File.dirname(__FILE__) + '/neo')

def my_global_method(a,b)
  a + b
end

class AboutMethods < Neo::Koan

  def test_calling_global_methods
    assert_equal 5, my_global_method(2,3)
  end

  # NOTE:
  # FIXME: Getting a syntax error as I believe, need to check though, that
  # `assert_equal` may be calling eval under the covers.  It's basically
  # erroring out as expected in the next test!
  #
  #def test_calling_global_methods_without_parentheses
    #result = my_global_method 2, 3
    #assert_equal 5, result
  #end

  # (NOTE: We are Using eval below because the example code is
  # considered to be syntactically invalid).
  def test_sometimes_missing_parentheses_are_ambiguous
    eval "assert_equal(5, my_global_method(2, 3))" # ENABLE CHECK
    #
    # Ruby doesn't know if you mean:
    #
    #   assert_equal(5, my_global_method(2), 3)
    # or
    #   assert_equal(5, my_global_method(2, 3))
    #
    # Rewrite the eval string to continue.
    #
  end

  # NOTE: wrong number of arguments is not a SYNTAX error, but a
  # runtime error.
  def test_calling_global_methods_with_wrong_number_of_arguments
    exception = assert_raise(ArgumentError) do
      my_global_method
    end
    assert_match(/wrong number/, exception.message)

    exception = assert_raise(ArgumentError) do
      my_global_method(1,2,3)
    end
    assert_match(/wrong number/, exception.message)
  end

  # ------------------------------------------------------------------

  # Is it preferrable to write `b='foo'` or `b = 'foo'`
  # Going with the latter as it's easier on the eyes, correcting below
  def method_with_defaults(a, b = :default_value)
    [a, b]
  end

  def test_calling_with_default_values
    assert_equal [1, :default_value], method_with_defaults(1)
    assert_equal [1, 2], method_with_defaults(1, 2)
  end

  # ------------------------------------------------------------------

  def method_with_var_args(*args)
    args
  end

  def test_calling_with_variable_arguments
    assert_equal Array, method_with_var_args.class
    assert_equal [], method_with_var_args
    assert_equal [:one], method_with_var_args(:one)
    assert_equal [:one, :two], method_with_var_args(:one, :two)
  end

  # ------------------------------------------------------------------

  def method_with_explicit_return
    :a_non_return_value
    return :return_value
    :another_non_return_value
  end

  def test_method_with_explicit_return
    assert_equal :return_value, method_with_explicit_return
  end

  # ------------------------------------------------------------------

  def method_without_explicit_return
    :a_non_return_value
    :return_value
  end

  def test_method_without_explicit_return
    assert_equal :return_value, method_without_explicit_return
  end

  # ------------------------------------------------------------------

  def my_method_in_the_same_class(a, b)
    a * b
  end

  def test_calling_methods_in_same_class
    assert_equal 12, my_method_in_the_same_class(3,4)
  end

  def test_calling_methods_in_same_class_with_explicit_receiver
    assert_equal 12, self.my_method_in_the_same_class(3,4)
  end

  # ------------------------------------------------------------------

  def my_private_method
    "a secret"
  end
  private :my_private_method

  def test_calling_private_methods_without_receiver
    assert_equal "a secret", my_private_method
  end

  class President
    def initialize(name, location)
      @name = name
      @location = location
    end

    attr_reader :name, :location
  end

  def test_calling_private_methods_with_an_explicit_receiver
    exception = assert_raise(NoMethodError) do
      self.my_private_method
    end
    assert_match /private method/, exception.message

    # However, you can use `#send` or `#__send__` if `#send` has been overriden
    assert_equal "a secret", self.send(:my_private_method)
    assert_equal "a secret", self.__send__(:my_private_method)

    my_icbm = Class.new do
      def initialize(authority)
        @authority = authority
      end

      def send(target)
        "hey, I've been overriden! Unable to launch!"
      end

      private
      def say_bye_bye_to(target)
        "Bye bye #{target.name}!"
      end
    end

    us_president = President.new('Obama', 'Washington D.C.')
    russian_president = President.new('Putin', 'Moscow')
    assert_match /Unable to launch/, my_icbm.new(us_president).send(russian_president)
    assert_match /Bye bye/, my_icbm.new(us_president).__send__(:say_bye_bye_to, russian_president)
  end

  # ------------------------------------------------------------------

  class Dog
    def name
      "Fido"
    end

    private

    def tail
      "tail"
    end
  end

  def test_calling_methods_in_other_objects_require_explicit_receiver
    rover = Dog.new
    assert_equal "Fido", rover.name
  end

  def test_calling_private_methods_in_other_objects
    rover = Dog.new
    assert_raise(NoMethodError) do
      rover.tail
    end

    # NOTE: Following the preceeding example of sending putin a little gift, we can
    # call `#send` on objects, as a last resort.
    #
    # However, we'd be calling methods not part of the public API. Private
    # methods are private for a reason!
    assert_equal "tail", rover.send(:tail)
  end
end
