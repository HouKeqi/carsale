package com.ruoyi.carsale.websocket;

import com.alibaba.fastjson2.JSON;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 库存提醒WebSocket服务端
 * 
 * @author ruoyi
 */
@Component
@ServerEndpoint("/websocket/stock-alert/{userId}")
public class StockAlertWebSocket {

    private static final Logger log = LoggerFactory.getLogger(StockAlertWebSocket.class);

    /**
     * 存储每个用户对应的WebSocket连接
     * key: userId, value: WebSocket会话
     */
    private static final ConcurrentHashMap<Long, Session> userSessions = new ConcurrentHashMap<>();

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") Long userId) {
        userSessions.put(userId, session);
        log.info("用户 {} 连接WebSocket成功，当前在线人数: {}", userId, userSessions.size());
        
        // 发送连接成功消息
        sendMessage(session, JSON.toJSONString(new WebSocketMessage("connected", "连接成功")));
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(@PathParam("userId") Long userId) {
        userSessions.remove(userId);
        log.info("用户 {} 断开WebSocket连接，当前在线人数: {}", userId, userSessions.size());
    }

    /**
     * 收到客户端消息后调用的方法
     */
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("userId") Long userId) {
        log.info("收到用户 {} 的消息: {}", userId, message);
        // 可以处理客户端发送的心跳消息等
    }

    /**
     * 发生错误时调用
     */
    @OnError
    public void onError(Session session, Throwable error, @PathParam("userId") Long userId) {
        log.error("用户 {} 的WebSocket连接发生错误", userId, error);
        userSessions.remove(userId);
    }

    /**
     * 发送消息给指定用户
     */
    public static void sendMessageToUser(Long userId, WebSocketMessage message) {
        Session session = userSessions.get(userId);
        if (session != null && session.isOpen()) {
            sendMessage(session, JSON.toJSONString(message));
        }
    }

    /**
     * 发送消息
     */
    private static void sendMessage(Session session, String message) {
        try {
            if (session != null && session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        } catch (IOException e) {
            log.error("发送WebSocket消息失败", e);
        }
    }

    /**
     * 获取在线用户数
     */
    public static int getOnlineCount() {
        return userSessions.size();
    }

    /**
     * WebSocket消息封装类
     */
    public static class WebSocketMessage {
        private String type;
        private Object data;
        private String message;

        public WebSocketMessage(String type, Object data) {
            this.type = type;
            this.data = data;
        }

        public WebSocketMessage(String type, String message) {
            this.type = type;
            this.message = message;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public Object getData() {
            return data;
        }

        public void setData(Object data) {
            this.data = data;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
