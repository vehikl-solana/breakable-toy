require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'a user is created with a filled out name and email' do
    name = 'John Doe'
    email = 'email@example.com'
    user = User.new(name: name, email: email)

    assert user.save
    result = User.all

    assert_equal(1, result.count)
    assert_equal(name, result[0].name)
    assert_equal(email, result[0].email)
  end

  test 'a user cannot be created without a name and email' do
    user = User.new
    assert_not user.save
    assert user.errors
    assert_equal(2, user.errors.count)
  end
end
