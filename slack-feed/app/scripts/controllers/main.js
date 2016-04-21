'use strict';

/**
 * @ngdoc function
 * @name slackFeedApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the slackFeedApp
 */
angular.module('slackFeedApp')
	.controller('MainCtrl', function (UserService, $scope) {
	
	// $scope.clearData = function() {
	// 	$scope.data = {};
	// };

	// $scope.getData = function(){
		// Call the async method and then do stuff with what is returned inside our own then function
		UserService.async().then(function(d) {
			$scope.data = d;
		});
	// };
	
	console.log("wsUrl: " + $scope.data)
  }).factory('UserService', function($http){
  		// Get the websocket url - http://stackoverflow.com/questions/12505760/processing-http-response-in-service
	
		var promise;
		var UserService = {
			async: function(){
				if ( !promise ) {
					var rtmUrl = 'https://slack.com/api/rtm.start?token=' + "xoxp-32797682641-36633406323-36685007797-76c510c493" + '&pretty=1'
			        // $http returns a promise, which has a then function, which also returns a promise
			        promise = $http.get(rtmUrl).then(function (response) {
						// The then function here is an opportunity to modify the response
						console.log("url is " + response.data.url);
						// The return value gets picked up by the then in the controller.
						return response.data;
		        	});
			    }
			    // Return promise to controller
			    return promise;
			}
		};
		return UserService;
  });
