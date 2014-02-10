def select_supply(supply = "Gauze")
  select supply, from: "order_supply_id"
end

When(/^I place a request$/) do
  visit '/orders/new'
end

When(/^I give it all inputs but "(.*?)"$/) do |field|
  fill_in "Location", :with => "loc but arg"
  fill_in "Special instructions area",  :with => "S/I/A but"
  click_button "Submit"
end

When(/^I give it all inputs but location$/) do
  # FYI: Do nothing for "Locaton"
  fill_in "Special instructions area",  :with => "S/I/A location"
  select_supply
  click_button "Submit"
end

When(/^I give it all the valid inputs$/) do
  fill_in "Location", :with => "loc valid inputs"
  fill_in "Special instructions area", :with => "S/I/A valid"
  select_supply
  click_button "Submit"
end

#P9 (SUCCESS)
Then(/^I see a successful request message$/) do
  pos_ack_msg "Success! The Order you placed on behalf of"
end

# ERRORS
Then(/^I see a invalid supply request message$/) do
  err_msg "Supply is missing"
end

Then(/^I see an invalid "(.*?)" request message$/) do |field|
  err_msg "#{field} is missing"
end

Then(/^I see a nonnumber "(.*?)" request message$/) do |field|
  err_msg "#{field} is not a number"
end

Then(/^I stay on Request Form page$/) do
  expect(current_url).to eq("http://www.example.com/orders")
end

Then(/^I stay on Request Manager page$/) do
  expect(current_url).to eq("http://www.example.com/orders/manage")
end

Then(/^I stay on Admin Home page$/) do
  expect(current_url).to eq("http://www.example.com/admin/users/new")
end

Then(/^I stay on Place a Request page$/) do
  expect(current_url).to eq("http://www.example.com/orders")
end

When(/^I place a request for "(.*?)"$/) do |name|
  visit '/orders/new'
  select name, from: "order_user_id"
end

When(/^I unselect volunteer$/) do
  select 'Select Volunteer to request for', from: 'order[user_id]'
end

Given(/^I select duration "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I see lines in the pending table$/) do
  count = page.all('table#pending-orders tr').count - 1
  expect(count).not_to eq(0)
end

Then(/^I see lines in the past_due table$/) do
  count = page.all('table#past-due-orders tr').count - 1
  expect(count).not_to eq(0)
end

Then(/^I see no lines in the request_tracker table$/) do
  count = page.all('table#responded-orders tr').count - 1
  expect(count).to eq(0)
end

Then(/^I see (\d+) lines in the pending table$/) do |expected_lines|
  history_orders_in_table = 
  history_orders_in_table.should == expected_lines.to_i
end

Then(/^I see (\d+) lines in the past_due table$/) do |expected_lines|
  history_orders_in_table = page.all('table#past-due-orders tr').count - 1
  history_orders_in_table.should == expected_lines.to_i
end
Then(/^I see (\d+) lines in the request_tracker table$/) do |expected_lines|
  history_orders_in_table = page.all('table#responded-orders tr').count - 1
  history_orders_in_table.should == expected_lines.to_i
end

When(/^I choose the country "(.*?)"$/) do |name|
  select name, from: 'admin_country_select'
end

When(/^I unselect the country$/) do
  select 'Country', from: 'admin_country_select'
end

Then(/^I see (\d+) lines in the table$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

#save_and_open_page
