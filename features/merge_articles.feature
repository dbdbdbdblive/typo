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
  | type    | user_name| title    | body                   | state      |
  | Article | admin1   | Title1   | <p>Article1 Body1</p>  | published  |
  | Article | admin1   | Title2   | <p>Article2 Body2</p>  | published  |
  | Article | contr1   | Title3   | <p>Article3 Body3</p>  | published  |
  | Article | publi1   | Title4   | <p>Article4 Body4</p>  | published  |

# 1-1B.1 A non-admin should not be able to merge
Scenario:
  Given I am logged in as a publisher user
  And I am on the edit page of Title4
  Then I should not see "Merge Articles"

Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  Then I should see "Merge Articles"

# 1-1B.2 When articles are merged, the merged article should contain the text of both previous articles
Scenario:
  Given I am logged in as an admin user
  And I am on the edit page of Title1
  And I fill in "Article ID" with the ID of Title2
  And I press "Merge"
  Then I should be on the admin content page
  When I go to the show page of Title1
  Then I should see the body content of Title1 and the body content of Title2
  

# Do not test contributor - the blog currently infinitely redirects when
# a contributor user tries to access any admin content, such as edit
#Scenario:
#  Given I am logged in as a contributor user
#  And I am on the edit page of Title3
#  Then I should not see "Merge Articles"
