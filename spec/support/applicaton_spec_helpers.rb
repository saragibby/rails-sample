def login(user)
  visit "/signin"
  within("#sign-in") do
    fill_in "Email",        :with => user.email
    fill_in "Password",     :with => user.password
  end
  click_button "Sign in"
end

def create_story_board_with_file(filename)
  visit new_story_board_path
  attach_file 'story_board_attachments_attributes_0_upload', Rails.root.join('spec/fixtures/',filename)
  click_button 'Save'
end