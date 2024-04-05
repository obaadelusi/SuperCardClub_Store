require "application_system_test_case"

class AlignmentsTest < ApplicationSystemTestCase
  setup do
    @alignment = alignments(:one)
  end

  test "visiting the index" do
    visit alignments_url
    assert_selector "h1", text: "Alignments"
  end

  test "should create alignment" do
    visit alignments_url
    click_on "New alignment"

    fill_in "Name", with: @alignment.name
    click_on "Create Alignment"

    assert_text "Alignment was successfully created"
    click_on "Back"
  end

  test "should update Alignment" do
    visit alignment_url(@alignment)
    click_on "Edit this alignment", match: :first

    fill_in "Name", with: @alignment.name
    click_on "Update Alignment"

    assert_text "Alignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Alignment" do
    visit alignment_url(@alignment)
    click_on "Destroy this alignment", match: :first

    assert_text "Alignment was successfully destroyed"
  end
end
