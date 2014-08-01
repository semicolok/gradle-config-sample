<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html data-ng-app="testBoard">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Test Board project</title>
  <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>
  <script src="https://raw.github.com/jmesnil/stomp-websocket/master/lib/stomp.js"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular.min.js" type="text/javascript"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.19/angular-route.min.js" type="text/javascript"></script>
  <script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
  <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="/resources/css/main.css" rel="stylesheet">
  
</head>
<body >
  <!-- navbar -->
  <div class="navbar navbar-inverse navbar-fixed-top" role="navigation" data-ng-include="'/d/resources/app/template/navbar.html'"></div>
  
  <div class="container-fluid">
    <div class="row">
      <!-- sidebar -->
      <div class="col-sm-3 col-md-2 sidebar" data-ng-include="'/d/resources/app/template/sidebar.html'"></div>
      <!-- main -->
      <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main" role="main" data-ng-view></div>
    </div>
  </div>

  <script src="/d/resources/app/config/index.js"></script>
  <script src="/d/resources/app/controller/mainController.js"></script>
  
  
  
  
  
  <div>
    <div id="connect-container">
        <input id="radio1" type="radio" name="group1" onclick="updateUrl('/d/echo');">
            <label for="radio1">W3C WebSocket</label>
        <br>
        <input id="radio2" type="radio" name="group1" onclick="updateUrl('/d/echojs');">
            <label for="radio2">SockJS</label>
        <div id="sockJsTransportSelect" style="visibility:hidden;">
            <span>SockJS transport:</span>
            <select onchange="updateTransport(this.value)">
              <option value="all">all</option>
              <option value="websocket">websocket</option>
              <option value="xhr-polling">xhr-polling</option>
              <option value="jsonp-polling">jsonp-polling</option>
              <option value="xhr-streaming">xhr-streaming</option>
              <option value="iframe-eventsource">iframe-eventsource</option>
              <option value="iframe-htmlfile">iframe-htmlfile</option>
            </select>
        </div>
        <div>
            <button id="connect" onclick="connect();">Connect</button>
            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
        </div>
        <div>
            <textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
        </div>
    </div>
    <div id="console-container">
        <div id="console"></div>
    </div>
</div>



<script type="text/javascript">
        var ws = null;
        var url = null;
        var transports = [];

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('echo').disabled = !connected;
        }

        function connect() {
            if (!url) {
                alert('Select whether to use W3C WebSocket or SockJS');
                return;
            }

            ws = (url.indexOf('echojs') != -1) ? 
                new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

            ws.onopen = function () {
                setConnected(true);
                log('Info: connection opened.');
            };
            ws.onmessage = function (event) {
                log('Received: ' + event.data);
            };
            ws.onclose = function (event) {
                setConnected(false);
                log('Info: connection closed.');
                log(event);
            };
        }

        function disconnect() {
            if (ws != null) {
                ws.close();
                ws = null;
            }
            setConnected(false);
        }

        function echo() {
            if (ws != null) {
                var message = document.getElementById('message').value;
                log('Sent: ' + message);
                ws.send(message);
            } else {
                alert('connection not established, please connect.');
            }
        }

        function updateUrl(urlPath) {
            if (urlPath.indexOf('echojs') != -1) {
                url = urlPath;
                document.getElementById('sockJsTransportSelect').style.visibility = 'visible';
            } else {
              if (window.location.protocol == 'http:') {
                  url = 'ws://' + window.location.host + urlPath;
              } else {
                  url = 'wss://' + window.location.host + urlPath;
              }
              document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';
            }
        }

        function updateTransport(transport) {
          transports = (transport == 'all') ?  [] : [transport];
        }
        
        function log(message) {
            var console = document.getElementById('console');
            var p = document.createElement('p');
            p.style.wordWrap = 'break-word';
            p.appendChild(document.createTextNode(message));
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
            console.scrollTop = console.scrollHeight;
        }
        function clear() {
            $('#message').html('');
        }
    </script>


</body>
</html>
