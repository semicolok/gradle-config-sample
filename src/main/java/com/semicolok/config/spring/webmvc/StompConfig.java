package com.semicolok.config.spring.webmvc;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableWebSocketMessageBroker
//public class StompConfig implements WebSocketMessageBrokerConfigurer {
public class StompConfig extends AbstractWebSocketMessageBrokerConfigurer {
    
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/stomp/simplemessages");
//        registry.addEndpoint("/stomp/simplemessages").withSockJS();
    }
    
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
//        registry.enableStompBrokerRelay("/stomp/subscribe");
        registry.enableSimpleBroker("/stomp/subscribe");
        registry.setApplicationDestinationPrefixes("/stomp/app");
    }

//    @Override
//    public void configureWebSocketTransport(WebSocketTransportRegistration registry) {
//    }
//
//    @Override
//    public void configureClientInboundChannel(ChannelRegistration registration) {
//    }
//
//    @Override
//    public void configureClientOutboundChannel(ChannelRegistration registration) {
//    }
//
//    @Override
//    public boolean configureMessageConverters(List<MessageConverter> messageConverters) {
//        return true;
//    }
}
