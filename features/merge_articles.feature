Feature: Merge Articles
  As an admin
  In order to simplify the site when more than one article is written on the same topic
  I want to merge two articles into one article

Background:
  Given the blog is set up
  And the following users exist:
  | profile_type  |
  | admin         |
  | contributor   |
  | publisher     |

  And the following articles exist:
  | type    | user_name| title    | body            | comment     | state      |
  | Article | admin1   | Title1   | Article1 Body1  | Comment1    | published  |
  | Article | publi1   | Title2   | Article2 Body2  | Comment2    | published  |
  | Article | contr1   | Title3   | Article3 Body3  | Comment3    | published  |
  | Article | publi1   | Title4   | Article4 Body4  | Comment4    | published  |



# 1-1B.1 A non-admin should not be able to merge
@hw1-1b.1
Scenario:
  Given I am logged in as a publisher user
  And I am on the edit page of Title4
  Then I should see "Uploads"
  And I should not see "Merge Articles"

@hw1-1b.1
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  Then I should see "Merge Articles"
  And I should see "Article ID:"

# 1-1B.2 When articles are merged, the merged article should contain the text of both previous articles
@hw1-1b.2
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  When I fill in "merge_with" with the ID of Title2
  And I press "Merge"
  Then I should be on the admin content page
  When I go to the show page of Title1
  Then I should see "Article1 Body1"
  And I should see "Article2 Body2"

# 1-1B.3: When articles are merged, the merged article should have one author (either one of the authors of the original article)
@hw1-1b.3
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  And I fill in "Article ID" with the ID of Title2
  And I press "Merge"
  Then I should be on the admin content page
  And I should see the author of Title1 is "admin1"
  And I should not see the author of Title1 is "publi1"

# 1-1B.4: Comments on each of the two original articles need to all carry over and point to the new, merged article
@hw1-1b.4
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  And I fill in "Article ID" with the ID of Title2
  And I press "Merge"
  Then I should be on the admin content page
  When I go to the show page of Title1
  Then I should see "Comment1"
  And I should see "Comment2"
  And I should not see "Comment3"

# 1-1B.5: The title of the new article should be the title from either one of the merged articles.
@hw1-1b.5
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  And I fill in "Article ID" with the ID of Title2
  And I press "Merge"
  Then I should be on the admin content page
  And I should see "Title1"
  And I should not see "Title2"

# Do not test contributor - the blog currently infinitely redirects when
# a contributor user tries to access any admin content, such as edit
#@hw1-1b.1
#Scenario:
#  Given I am logged in as a contributor user
#  And I am on the edit page of Title3
#  Then I should not see "Merge Articles"
