require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should create user" do
    user = User.new(
      name: 'NewUserName',
      email: 'username@mail.com',
      password: '123456', 
      password_confirmation: '123456')
    assert user.valid?
  end

  test "should not create without password" do
    user = User.new(
      name: 'Username',
      email: 'uname@mail.com',
      password_confirmation: '123456')
    assert_not user.valid?
  end

  test "should not create with password mismatch" do
    user = User.new(
      name: 'Username',
      email: 'uname@mail.com',
      password: '123456',
      password_confirmation: '1234567890')
    assert_not user.valid?
  end

end
