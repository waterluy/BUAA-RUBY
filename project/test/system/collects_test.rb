require "application_system_test_case"

class CollectsTest < ApplicationSystemTestCase
  setup do
    @collect = collects(:one)
  end

  test "visiting the index" do
    visit collects_url
    assert_selector "h1", text: "Collects"
  end

  test "should create collect" do
    visit collects_url
    click_on "New collect"

    click_on "Create Collect"

    assert_text "Collect was successfully created"
    click_on "Back"
  end

  test "should update Collect" do
    visit collect_url(@collect)
    click_on "Edit this collect", match: :first

    click_on "Update Collect"

    assert_text "Collect was successfully updated"
    click_on "Back"
  end

  test "should destroy Collect" do
    visit collect_url(@collect)
    click_on "Destroy this collect", match: :first

    assert_text "Collect was successfully destroyed"
  end
end
