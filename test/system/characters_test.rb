require "application_system_test_case"

class CharactersTest < ApplicationSystemTestCase
  setup do
    @character = characters(:one)
  end

  test "visiting the index" do
    visit characters_url
    assert_selector "h1", text: "Characters"
  end

  test "should create character" do
    visit characters_url
    click_on "New character"

    fill_in "Description", with: @character.description
    fill_in "Name", with: @character.name
    fill_in "Price", with: @character.price
    fill_in "Stat combat", with: @character.stat_combat
    fill_in "Stat durability", with: @character.stat_durability
    fill_in "Stat intelligence", with: @character.stat_intelligence
    fill_in "Stat power", with: @character.stat_power
    fill_in "Stat speed", with: @character.stat_speed
    fill_in "Stat strength", with: @character.stat_strength
    click_on "Create Character"

    assert_text "Character was successfully created"
    click_on "Back"
  end

  test "should update Character" do
    visit character_url(@character)
    click_on "Edit this character", match: :first

    fill_in "Description", with: @character.description
    fill_in "Name", with: @character.name
    fill_in "Price", with: @character.price
    fill_in "Stat combat", with: @character.stat_combat
    fill_in "Stat durability", with: @character.stat_durability
    fill_in "Stat intelligence", with: @character.stat_intelligence
    fill_in "Stat power", with: @character.stat_power
    fill_in "Stat speed", with: @character.stat_speed
    fill_in "Stat strength", with: @character.stat_strength
    click_on "Update Character"

    assert_text "Character was successfully updated"
    click_on "Back"
  end

  test "should destroy Character" do
    visit character_url(@character)
    click_on "Destroy this character", match: :first

    assert_text "Character was successfully destroyed"
  end
end
