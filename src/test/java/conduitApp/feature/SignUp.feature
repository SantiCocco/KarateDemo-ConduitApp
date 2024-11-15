Feature: Sign Up new user

  Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()
    Given url apiUrl

  Scenario: New user Sign up
    Given path 'users'
    And request
    """
    {
        "user": {
            "email": #(randomEmail),
            "password": "DemoKarate1234",
            "username": #(randomUsername)
        }
    }

    """
    When method POST
    Then status 201
    And match response ==
    """
    {
        "user": {
            "id": "#number",
            "email": "#(randomEmail)",
            "username": "#(randomUsername)",
            "bio": "##string",
            "image": "##string",
            "token": "#string"
        }
    }
    """

  Scenario Outline: Validate SignUp error messages
        Given path 'users'
        And request
        """
        {
            "user": {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
            }
        }
    
        """
        When method POST
        Then status 422
        And match response == <errorResponse>

        Examples:
      |       email          | password  |      username                 |               errorResponse                                        |
      | #(randomEmail)       | Karate123 |  KarateUser123                | {"errors":{"username":["has already been taken"]}}                 |
      | karateuser1@test.com | Karate123 |  #(randomUsername)            | {"errors":{"email":["has already been taken"]}}                    |
      |                      | Karate123 |  #(randomUsername)            | {"errors":{"email":["can't be blank"]}}                            |
      | #(randomEmail)       |           |  #(randomUsername)            | {"errors":{"password":["can't be blank"]}}                         |
      | #(randomEmail)       | Karate123 |                               | {"errors":{"username":["can't be blank"]}}                         |


