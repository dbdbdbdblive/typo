Given /^the blog is set up$/ do
  Blog.default.update_attributes!({:blog_name => 'Teh Blag',
                                   :base_url => 'http://localhost:3000'});
  Blog.default.save!
  User.create!({:login => 'admin',
                :password => 'aaaaaaaa',
                :email => 'joe@snow.com',
                :profile_id => 1,
                :name => 'admin',
                :state => 'active'})
end

And /^I am logged into the admin panel$/ do
  _login(login = 'admin', pw = 'aaaaaaaa')
end

####
Given /^the following users exist:$/ do |users_table|
#  users_table.hashes.each do |user|
#    User.create!(:login => user['login'], :password => user['password'], :email => user[:email], :profile => Profile.find_by_label(user[:profile_label]), :name => user[:name], :state => user[:state])
#  end

  profile_types = []
  users_table.hashes.each do |user|
    profile_types.push(user[:profile_type])
  end
  
  users = _get_users(profile_types)
  users.each { |user| User.create!(user) }
end

Given /^the following articles exist:$/ do |articles_table|
  articles_table.hashes.each do |article|
    user = User.find_by_name(article['user_name'])
    _article = Article.create!(:type=>article['type'], :author=>user.name, :user_id=>user.id, :title=>article['title'], :body=>article['body'], :state=>article['state'])
    if article['comment']    
      Comment.create!(:body=>article['comment'], :user_id=>user.id, :article_id=>_article.id, :author=>user.name)
    end
  end
end

Given /^I am logged in as a[n]? (admin|contributor|publisher) user$/ do |profile_label|
  _user = _get_users([profile_label])[0]
  _login(login=_user[:login], pw=_user[:password])
end

When /^(?:|I )fill in "(.+)" with the ID of ([^"]*)$/ do |field, article_title|
  article = Article.find_by_title(article_title)
  fill_in(field, :with => article.id)
end

Then /^(?:|I )should (not )?see the author of ([^"]*) is "([^"]*)"$/ do |exclude, title, author|
  #xpath matcher: the list of articles should have a table with a row that has
  #a td with a link with the title, and a sibling td containing the author's name 
  #note there is another sibling td between them for the category
  #page.should have_xpath("//tr//td[a[contains(.,#{title})]]/following-sibling::td/following-sibling::td/#{author}")
  xpath_matcher = page.find(:xpath, "//tr//td[a[contains(.,'#{title}')]]/following-sibling::td/following-sibling::td")
  if exclude
    xpath_matcher.should_not have_content("#{author}")
  else
    xpath_matcher.should have_content("#{author}")
  end
end

#DB Helpers
def _get_users(profile_types)
  users = []
  profile_types.each do |profile_type|
    user = {}
    #generate a "short name" based on the the first 5 characters + a number
    #use this short name for fields that need to be unique
    user_sn = profile_type.byteslice(0..4) + "1"
    user[:login] = user_sn
    user[:password] = "#{user_sn}_pw"
    user[:email] = "#{user_sn}@#{profile_type}\.com"
    user[:profile] = Profile.find_by_label(profile_type)
    user[:name] = "#{user_sn}"
    user[:state] = "active"
    users.push(user)
  end
  users
end

def _login(login, pw)
  visit '/accounts/login'
  fill_in 'user_login', :with => login
  fill_in 'user_password', :with =>  pw
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end


