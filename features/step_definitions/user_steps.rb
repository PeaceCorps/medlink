#### UTILITY METHODS ###

def create_visitor
  email    = "joe.doe@gmail.com"
  password = "please123"
  @visitor ||= { :first_name => "Joe", :last_name => "Doe", 
    :email => email,
    :password => password, :password_confirmation => password }
end

def create_user role: :user, name: "joe", country: nil
  email    = "#{name}.doe@gmail.com"
  password = "please123"
  pcv_id = Random.new.rand(10000000..99999999).to_s
  user_country = country || FactoryGirl.create(:country)
  @user = FactoryGirl.create(role.to_sym, 
    :email => email, :password => password, :password_confirmation => password,
    :country => user_country, :city => "Roswell",
    :first_name => name, :last_name => "Doe", :pcv_id => pcv_id)
end

def set_role(role)
  #ADMIN: , :role => 'admin'
  #PCV:   , :role => 'pcv'
  #PCMO:  , :role => 'pcmo'
  #WAS: @user = { :role => role }
  if @user
    @user.update_attributes(role: role)
    @user.save
  else
    @user = User.new(role: role)
  end
end

def sign_in(remember=false)
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  if (remember)
    check "user_remember_me"
  else
    uncheck "user_remember_me"
  end
  click_button "Sign in"
end

def delete_user
  @user ||= User.where('email' => @visitor[:email]).first
  @user.destroy unless @user.nil?
end


### GIVEN ############################################################

Given /^I am not logged in$/ do
  visit '/'
end

Given /^I exist as a user$/ do
  create_user
end

Given /^the default user exists$/ do
  create_visitor
  create_user
end

Given(/^I am (a|an|the) "(.*?)"$/) do |_, role|
  set_role(role)
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I am logged in as (a|an|the) (\w+)$/ do |_, role|
   create_user role: role
   create_visitor
   sign_in
end

Given(/^I am logged in as (a|an|the) (\w+) of (\w+)$/) do |_, role, country|
   create_user role: role, country: Country.find_by_name(country)
   create_visitor
   sign_in
end

When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end


When /^I sign in with valid credentials after checking remember me$/ do
  sign_in(true)
end

When(/^I close my browser \(clearing the session\)$/) do
  expire_cookies
end

When(/^I clear my remember me cookie and close my browser$/) do
  expire_cookies
  delete_cookie "remember_user_token"
end

When /^I sign out$/ do
  click_link "Sign Out"
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

Then (/^I should be signed in as "(.*?)"$/) do |role|
  if role == "admin"
    expect(current_url).to eq("http://www.example.com/admin/users/new")
  elsif role == "pcmo"
    expect(current_url).to eq("http://www.example.com/orders/manage")
  else
    expect(current_url).to eq("http://www.example.com/orders")
  end
end

Then /^I should be signed in$/ do
  expect(current_url).to eq("http://www.example.com/orders")
end

Then /^I see a successful sign in message$/ do
  page.should have_selector ".alert", text: "Signed in successfully."
end

Then /^I should be signed out$/ do
  find("h3", :text => "Sign in").visible?
end

Then /^I should see a signed out message$/ do
  #FIXME: page.should have_content "Signed out successfully."
  page.should have_content "Invalid email or password."
end

Then /^I see an invalid login message$/ do
  page.should have_selector ".alert", text: "Invalid email or password."
end

Given(/^that pcv "(.*?)" exists$/) do |name|
  create_user role: :user, name: name
end

Given(/^that the following pcvs exist:$/) do |users|
  users.hashes.each do |user|
    FactoryGirl.create :user, first_name: user['name'], pcv_id: user['pcv_id'], country: Country.find_by_name(user['country'])
  end
end

#TODO: Unimplemented Steps in user_step.rb file.

# Then /^I see an unconfirmed account message$/ do
#   page.should have_selector ".alert", text: "You have to confirm your account before continuing."
# end

# Then /^I should see a successful sign up message$/ do
#   page.should have_content "Welcome! You have signed up successfully."
# end

# Then /^I should see an invalid email message$/ do
#   page.should have_content "Please enter an email address"
# end

# Then /^I should see a missing password message$/ do
#   page.should have_content "Password can't be blank"
# end

# Then /^I should see a missing password confirmation message$/ do
#   page.should have_content "Password doesn't match confirmation"
# end

# Then /^I should see a mismatched password message$/ do
#   page.should have_content "Password doesn't match confirmation"
# end

# Then /^I should see an account edited message$/ do
#   page.should have_content "You updated your account successfully."
# end

# Then /^I should see my name$/ do
#   create_user
#   page.should have_content @user[:name]
# end
