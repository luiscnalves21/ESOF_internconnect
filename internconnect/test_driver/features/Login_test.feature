Feature: Main Screen Validates and then logs in
    
    
    Scenario: when email and password are in specified format and login is clicked
        Given I have "emailfield" and "passfield" and "LoginButton"
        When I fill the "emailfield" field with "myemail@gmail.com"
        And I fill the "passfield" field with "passwordwith_@"
        Then I tap the "LoginButton"
        Then I should have "HomePage" on screen