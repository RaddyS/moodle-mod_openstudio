@ou @ou_vle @mod @mod_openstudio @mod_openstudio_manage_folders
Feature: Export to my contents
    In order to export my contents
    As a student
    I need to be able to export my contents

    Background: Setup course and studio
        Given the following "users" exist:
            | username | firstname | lastname | email            |
            | teacher1 | Teacher   |  1       | teacher1@asd.com |
        And the following "courses" exist:
            | fullname | shortname | category | format      |
            | Course 1 | C1        | 0        | oustudyplan |
        And the following "course enrolments" exist:
            | user     | course    | role     |
            | teacher1 | C1        | manager  |

        # Enable REST web service
        And I log in as "admin"
        And the following config values are set as admin:
            | enablewebservices | 1 |
            | enableportfolios  | 1 |
        And I navigate to "Manage protocols" node in "Site administration > Plugins"
        And I click on "Enable" "link" in the "REST protocol" "table_row"
        And I press "Save changes"
        And I navigate to "Manage portfolios" node in "Site administration > Plugins"
        And I set portfolio instance "File download" to "Enabled and visible"
        And I press "Save"
        And I log out

        # Create an Open Studio activity
        Given I am using the OSEP theme
        And I log in as "teacher1" (in the OSEP theme)
        And I follow "Course 1"
        And the following open studio "instances" exist:
            | course | name           | description                | pinboard | idnumber | tutorroles |
            | C1     | Sharing Studio | Sharing Studio description | 99       | OS1      | manager    |

        And the following open studio "contents" exist:
            | openstudio | user     | name      | description           | file                                       | visibility |
            | OS1        | teacher1 | Content 1 | Content Description 1 | mod/openstudio/tests/importfiles/test1.jpg | module     |
            | OS1        | teacher1 | Content 2 | Content Description 2 | mod/openstudio/tests/importfiles/test2.jpg | module     |

        And all users have accepted the plagarism statement for "OS1" openstudio
        And I turn editing mode on in the OSEP theme

    @javascript
    Scenario: Export

        Given I am on site homepage
        And I follow "Course 1"
        And I follow "Sharing Studio"

        # Export all contents
        And I follow "My Content"
        And I click on "#osep-bottombutton-export" "css_element"
        And I press "All content shown"
        Then I should see "Downloading ..."

        # Export selected posts
        And I am on site homepage
        And I follow "Course 1"
        And I follow "Sharing Studio"
        And I follow "My Content"
        And I follow "Export"
        And I press "Selected posts"
        And I click on "//label[contains(normalize-space(.), 'Content 1')]" "xpath_element"
        And I press "Export selected posts"
        Then I should see "Downloading ..."