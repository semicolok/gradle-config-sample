app.controller('MainCtrl', function($scope, $timeout) {
  //STARTOFCONTROLLER
  $scope.message = '';
  $scope.ws;
  $scope.echoMessages = [];

  $scope.init = function() {
    $scope.boardList = [1,2,3,4,5,6,7,8];

    console.log($scope.boardList);
      
    // websocket
    $scope.ws = new WebSocket('ws://localhost:8080/d/echo');
    $scope.ws.onopen = function() {
      console.log('websocket opened');
    };
    $scope.ws.onmessage = function(message) {
      console.log(message);
      console.log('receive message : ' + message.data);
      $scope.echoMessages.unshift(message.data);
      $timeout(function() {
        $scope.$apply('echoMessages');
      })
    };
    $scope.ws.onclose = function(event) {
      console.log(event);
      console.log('websocket closed');
    };
    
    
    // socketJs
    $scope.sock = new SockJS('http://localhost:8080/d/echojs');
    $scope.sock.onopen = function() {
      console.log('websocket opened');
    };
    $scope.sock.onmessage = function(message) {
      console.log(message);
      console.log('receive message : ' + message.data);
      $scope.echoJsMessages.unshift(message.data);
    };
    $scope.sock.onclose = function(event) {
      console.log(event);
      console.log('websocket closed');
    };
    
    // Stomp
    var socket = new WebSocket('ws://localhost:8080/d/stomp/simplemessages'); //SockJS endpoint를 이용
    $scope.client = Stomp.over(socket); //Stomp client 구성
    $scope.client.connect({}, function(frame) {
      console.log('connected stomp over sockjs');
      // subscribe message
      $scope.client.subscribe('/stomp/subscribe/echo', function(message) {
        console.log('receive subscribe');
        console.log(message);
      });
    });
    
  };
  
  //send message
  $scope.sendStt = function() {
    var data = {
      name: 'Test',
      message: 'TestMessage'
    };
    $scope.client.send('/stomp/app/echo', {}, JSON.stringify("test!!!!"));
//    $scope.client.send('/stomp/app/echo', {}, JSON.stringify(data));
  };

  $scope.send = function() {
    $scope.ws.send($scope.message);
  };
  
  $scope.sendJs = function() {
      $scope.sock.send($scope.messageJs);
  };

  $scope.init();
  //ENDOFCONTROLLER
});