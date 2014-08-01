var app = angular.module("testBoard", ['ngRoute']);

app.config(function($routeProvider){
   $routeProvider
     .when('/', {
        redirectTo: '/main'
     })
     .when('/main', {
	 controller : 'MainCtrl',
	 templateUrl : '/d/resources/app/template/main.html'
     });
});