Feature: Test for the home page

    Background: Define URL
        Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method Get 
        Then status 200
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        Given params {limit: 10, offset: 0} 
        Given path 'articles'
        When method Get
        Then status 200
        And match response == {"articles":"#[10]","articlesCount":"#number"}
        And match each response.articles ==
        """
            {
                "slug": '#string',
                "title": '#string',
                "description": '#string',
                "body": '#string',
                "tagList": '#array',
                "createdAt": '#? timeValidator(_)',
                "updatedAt": '#? timeValidator(_)',
                "favorited": '#boolean',
                "favoritesCount": '#number',
                "author": {
                    "username": '#string',
                    "bio": '##string',
                    "image": '#string',
                    "following": '#boolean'
            }
        }
        """
    @conditional
    Scenario: Conditional logic
        Given params {limit: 10, offset: 0} 
        Given path 'articles'
        When method Get
        Then status 200
        * def favoritesCount = response.articles[0].favoritesCount
        * def article = response.articles[0]
        #* if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature', article)
        * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature', article).likesCount : favoritesCount


        Given params {limit: 10, offset: 0} 
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == result

    @retry
    Scenario: Retry call
        * configure retry = { count: 10, interval: 5000 }

        Given params { limit: 10, offset: 0 } 
        Given path 'articles'
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        Then status 200

    @sleep
    Scenario: Sleep call
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

        Given params { limit: 10, offset: 0 } 
        Given path 'articles'
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        * eval sleep(5000)
        Then status 200

    @typeConvertion
    Scenario: Number to string
        * def foo = 10
        * def json = {"bar": #(foo+'')}
        * match json == {"bar": '10'}

    @typeConvertion
    Scenario: string to Number
        * def foo = '10'
        * def json = {"bar": #(foo*1)}
    #   * def json = {"bar": #(~~parseInt(foo))}  ~~ converts from double to integer
        * match json == {"bar": 10}