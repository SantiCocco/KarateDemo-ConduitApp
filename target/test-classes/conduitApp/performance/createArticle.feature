Feature: Articles

Background: Define URL
    * url apiUrl
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = __gatling.Title
    * set articleRequestBody.article.description = __gatling.Description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

    * def sleep = function(ms) { java.lang.Thread.sleep(ms) }
    * def pause = karate.get('__gatling.pause',sleep)

Scenario: Create and delete article
    * configure headers = {"Authorization": #('Token ' + __gatling.token)}
    And path 'articles'
    And request articleRequestBody
    When method POST
    Then status 201
    * def articleId = response.article.slug

    # * pause(5000)

    # Given path 'articles',articleId
    # When method DELETE
    # Then status 204