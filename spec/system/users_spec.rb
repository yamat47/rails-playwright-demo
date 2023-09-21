require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    # NOTE: specify the driver name by setting the DRIVER environment variable
    case ENV.fetch("DRIVER", "rack_test")
    when "rack_test"
      driven_by(:rack_test)
    when "selenium_chrome"
      driven_by(:selenium_chrome)
    when "selenium_chrome_headless"
      driven_by(:selenium_chrome_headless)
    when "playwright_chromium"
      driven_by(:playwright, options: { headless: false, browser_type: :chromium })
    when "playwright_chromium_headless"
      driven_by(:playwright, options: { headless: true, browser_type: :chromium })
    when "playwright_firefox"
      driven_by(:playwright, options: { headless: false, browser_type: :firefox })
    when "playwright_firefox_headless"
      driven_by(:playwright, options: { headless: true, browser_type: :firefox })
    when "playwright_webkit"
      driven_by(:playwright, options: { headless: false, browser_type: :webkit })
    when "playwright_webkit_headless"
      driven_by(:playwright, options: { headless: true, browser_type: :webkit })
    else
      raise "Invalid DRIVER: #{driver}"
    end
  end

  describe "User can create a new user" do
    specify do
      visit users_path

      expect(page).to have_text("Users")

      click_on "New user"

      expect(page).to have_text("New user")

      fill_in "Name", with: "Sample User"
      fill_in "Email", with: "sample-user@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"

      click_on "Create User"

      expect(page).to have_text("User was successfully created.")
      expect(page).to have_text("Sample User")
      expect(page).to have_text("sample-user@example.com")
      expect(page).not_to have_text("password")
    end
  end

  describe "User can edit a user" do
    before do
      User.create!(name: "Sample User", email: "sample-user@example.com", password: "password")
    end

    specify do
      visit users_path

      click_on "Show this user"

      expect(page).to have_text("sample-user@example.com")

      click_on "Edit this user"

      expect(page).to have_text("Editing user")

      fill_in "Name", with: "Another User"
      fill_in "Email", with: "another@example.com"
      fill_in "Password", with: "new-password"
      fill_in "Password confirmation", with: "new-password"

      click_on "Update User"

      expect(page).to have_text("User was successfully updated.")
      expect(page).to have_text("Another User")
      expect(page).to have_text("another@example.com")
      expect(page).not_to have_text("new-password")
    end
  end

  describe "User can delete a user" do
    before do
      User.create!(name: "Sample User", email: "sample-user@example.com", password: "password")
    end

    specify do
      visit users_path

      click_on "Show this user"

      expect(page).to have_text("sample-user@example.com")

      click_on "Destroy this user"

      expect(page).to have_text("User was successfully destroyed.")
      expect(page).not_to have_text("sample-user@example.com")
    end
  end
end
