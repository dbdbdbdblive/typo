Feature: Edit Categories
  As an admin
  In order to organize the site logically by categories
  I want to be able to create and edit categories

Background:
  Given the blog is set up
  And the following users exist:
  | profile_type  |
  | admin         |
  | contributor   |
  | publisher     |

#  And the following categories exist:
#  | name      |
#  | category1 |
#  | category2 |
#  | category3 |

  And the following articles exist:
  | type    | user_name| title    | body            | comment     | state      |
  | Article | admin1   | Title1   | Article1 Body1  | Comment1    | published  |
  | Article | publi1   | Title2   | Article2 Body2  | Comment2    | published  |
  | Article | contr1   | Title3   | Article3 Body3  | Comment3    | published  |
  | Article | publi1   | Title4   | Article4 Body4  | Comment4    | published  |


@hw1-2
Scenario:
  Given I am logged in as an admin user
  And I am on the admin content page
  When I follow "Categories"
  Then I should be on the new category page

@hw1-2
Scenario:
  Given I am logged in as an admin user
  And I am on the new category page
  When I fill in "category_name" with "Category1"
  And I press "Save"
  Then I should be on the new category page
  And I should see "Category was successfully saved"
  When I follow "Category1"
  Then I should be on the category page for Category1
  When I go to the edit page of Title1
  And I check "Category1"
  And I press "Publish"
  Then I should be on the admin content page
  And I should see the category of Title1 is Category1
