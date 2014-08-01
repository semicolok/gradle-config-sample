package com.semicolok.web.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {
    
    @MessageMapping("/echo")
    @SendTo("/stomp/subscribe/echo")
    public String echo(String message) {
        System.out.println(message);
        return "Echo : " + message;
    }
}
