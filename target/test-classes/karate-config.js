function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }
  if (env == 'dev') {
    //config.userEmail = "karautomation@test.com"
    //config.userPassword = "Karautomation"
  } 
  else if (env == 'qa') {
    //config.userEmail = "karautomationQA@test.com"
    //config.userPassword = "KarautomationQA"
  }

  //var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  //karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}