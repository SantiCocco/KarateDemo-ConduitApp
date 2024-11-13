Feature: Work WIth DB

Background:
    * def dbHandler = Java.type('helpers.DbHandler')

Scenario: Seed database with a new job
    * eval dbHandler.addNewJobWithName("QA6")

Scenario: Get level for job
    * def level = dbHandler.getMinAndMaxLevelsForJob("QA6")
    * print level.minLvl
    * print level.maxLvl
    And match level.minLvl == '50'
    And match level.minLvl == '100'
