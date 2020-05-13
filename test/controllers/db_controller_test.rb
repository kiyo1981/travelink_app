require 'test_helper'

class DbControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get db_index_url
    assert_response :success
  end

end
