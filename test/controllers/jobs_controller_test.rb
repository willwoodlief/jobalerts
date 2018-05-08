require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get jobs_list_url
    assert_response :success
  end

  test "should get update" do
    get jobs_update_url
    assert_response :success
  end

end
