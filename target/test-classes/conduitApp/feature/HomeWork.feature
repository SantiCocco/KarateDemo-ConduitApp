@ignore @parallel=false
Feature: Home Work

    Background: Preconditions
        * url apiUrl 
        * def dataGenerator = Java.type('helpers.DataGenerator')
 
    Scenario: Favorite articles
        * def favoriteResponseBody = read('classpath:conduitApp/json/postFavoriteArticleResponse.json')
        * def getFavoritedArticlesResponse = read('classpath:conduitApp/json/getFavoritedArticlesResponse.json')
        # Step 1: Get atricles of the global feed
        Given params {limit: 10, offset: 0}
        And path 'articles'
        When method Get
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * print (response)
        * def favoritesCount = response.articles[0].favoritesCount
        * print (favoritesCount)
        * def slugID = response.articles[0].slug
        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles/',slugID,'/favorite'
        And request {}
        When method Post
        Then status 200
        # Step 4: Verify response schema
        * print (response)
        And match response == favoriteResponseBody
        # Step 5: Verify that favorites article incremented by 1   
        * print (response.article.favoritesCount)
        And match response.article.favoritesCount == favoritesCount + 1

        # Step 6: Get all favorite articles
        Given params {favorited:'#(userEmail)', limit: 10, offset: 0}
        And path 'articles'
        When method Get
        Then status 200
              # Step 7: Verify response schema
        And match response == getFavoritedArticlesResponse
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles

    Scenario: Comment articles
        * def getCommentsResponseBody = read('classpath:conduitApp/json/getCommentsResponse.json')
        * def postCommentResponseBody = read('classpath:conduitApp/json/postCommentResponse.json')
        * def commentBody = dataGenerator.getRandomCommentBody()
        * def postCommentRequest = { "comment": { "body": "#(commentBody)" } }
        # Step 1: Get atricles of the global feed
        Given params {limit: 10, offset: 0}
        And path 'articles'
        When method Get
        Then status 200
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slugID = response.articles[0].slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles/',slugID,'/comments'
        When method Get
        Then status 200
        # Step 4: Verify response schema
        And match each response.comments == getCommentsResponseBody.comments[0]
        # Step 5: Get the count of the comments array lentgh and save to variable
            * def commentsCount = response.comments.length
        # Step 6: Make a POST request to publish a new comment
        Given path 'articles/',slugID,'/comments'
        And request postCommentRequest
        When method Post
        Then status 200
        # Step 7: Verify response schema that should contain posted comment text
        * def commentID = response.comment.id
        And match response == postCommentResponseBody
        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles/',slugID,'/comments'
        When method Get
        Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newCommentsCount = response.comments.length
        And match newCommentsCount == commentsCount + 1
        # Step 10: Make a DELETE request to delete comment
        Given path 'articles/',slugID,'/comments/',commentID
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles/',slugID,'/comments'
        When method Get
        Then status 200
        * def finalCommentsCount = response.comments.length
        And match finalCommentsCount == commentsCount