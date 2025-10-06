require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "will find and return users from the db from index endpoint" do
    users = create_pair(:user)

    get "/api/users", as: :json
    assert_response :success
    assert_equal users.to_json, @response.body
  end

  test "will be able to search for a specific user by name" do
    users = create_list(:user, 2)

    get "/api/users", params: { :query =>  users[0].name}
    assert_response :success
    assert_equal [users[0]].to_json, @response.body
  end

  test "it can return a single user" do
    users = create_pair(:user)

    expected_user = users[1]

    get "/api/users/#{expected_user.id}", as: :json
    assert_response :success
    assert_equal expected_user.to_json, @response.body
  end

  test "will throw a 404 if the user is not found" do
    get "/api/users/1", as: :json
    assert_response 404
  end

  test "will update a users name and email" do
    user = create(:user)
    data_to_update = {:name => 'Jake the Dog', :email => 'finntheboy@adventuretime.com'}

    patch "/api/users/#{user.id}", params: data_to_update ,as: :json
    assert_response :success

    expected_user = User.find(user.id)
    assert_equal expected_user.name, data_to_update[:name]
    assert_equal expected_user.email, data_to_update[:email]
  end

  [
    { test_case: 'missing name parameter', data: { email: 'jakethedog@adventuretime.com'} },
    { test_case: 'empty name parameter', data: { name: '', email: 'jakethedog@adventuretime.com'} },
    { test_case: 'missing email parameter', data: { name: 'Finn the Boy' } },
    { test_case: 'empty email parameter', data: { name: 'Finn the Boy', email: '' } },
  ].each do |data|
    test "will reject a request when provided with #{data[:test_case]}" do
      user = create(:user)

      patch "/api/users/#{user.id}", params: data[:data], as: :json
      assert_response :unprocessable_content

      expected_user = User.find(user.id)
      assert_equal expected_user.name, user[:name]
      assert_equal expected_user.email, user[:email]
    end
  end

  test "will create a user" do
    email = "myname@job.com"
    name = "John hill"
    post "/api/users", params: { email:, name: }, as: :json
    assert_response :success

    user = User.first
    assert_equal name, user.name
    assert_equal email, user.email
  end

  [
    {test_case: "missing name parameter", data: {email: 'Iamaemail@email.com'}},
    {test_case: "empty name parameter", data: {name: '', email: 'Iamaemail@email.com'}},
    {test_case: "missing email parameter", data: {name: 'Bobs your uncle' }},
    {test_case: "empty email parameter", data: {name: 'Bobs your uncle', email: '' }},
  ].each do |testData|
    test "will reject creating a user when #{testData[:test_case]}" do
      post "/api/users", params: testData[:data], as: :json
      assert_response :unprocessable_content

      assert_equal 0, User.count
    end
  end

  test "will delete a user" do
    user = User.create(name: 'Finn the Boy', email: 'jakethedog@adventuretime.com')

    delete "/api/users/#{user.id}", as: :json
    assert_response :success
    assert_equal 0, User.count
  end

  test "will throw a not found error if attempting to delete an ID that doesn't exist" do
    delete "/api/users/-500", as: :json
    assert_response :not_found
  end
end
