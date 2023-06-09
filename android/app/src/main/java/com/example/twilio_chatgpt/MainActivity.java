package com.example.twilio_chatgpt;

import static com.twilio.conversations.ConversationsClient.*;

import androidx.annotation.NonNull;

import com.twilio.conversations.CallbackListener;
import com.twilio.conversations.Conversation;
import com.twilio.conversations.ConversationListener;
import com.twilio.conversations.ConversationsClient;
import com.twilio.conversations.ConversationsClientListener;
import com.twilio.conversations.User;
import com.twilio.jwt.accesstoken.AccessToken;
import com.twilio.jwt.accesstoken.ChatGrant;
import com.twilio.util.ErrorInfo;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;



public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "twilio_chatgpt/twilio_sdk_connection";
    private static String generateAccessToken;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL) .setMethodCallHandler(
                      (call, result) -> {
                          System.out.println("MethodChannel");
                          if(Objects.equals(call.method,"generateToken")){
                              generateAccessToken(call.argument("accountSid"),call.argument("apiKey"),call.argument("apiSecret"),call.argument("identity"));
                          }
                          if(Objects.equals(call.method, "createConversation")){
                              createConversation(call.argument("conversationName"));
                          }
                          if(Objects.equals(call.method, "joinConversation")){
                              joinConversation();
                          }


        });
    }


    public static String generateAccessToken(String accountSid, String apiKey, String apiSecret, String identity) {
        // Create an AccessToken builder
        AccessToken.Builder builder = new AccessToken.Builder(accountSid, apiKey, apiSecret);

        // Set the identity of the token
        builder.identity(identity);

        // Create a Conversations grant and add it to the token
//        ConversationsGrant conversationsGrant = new ConversationsGrant();
//        builder.grant(conversationsGrant);

        // Create a Chat grant and add it to the token
        ChatGrant chatGrant = new ChatGrant();
        builder.grant(chatGrant);

        // Build the token
        AccessToken token = builder.build();

        // Return the token as a string
        System.out.println("Token");
        System.out.println(token.toJwt());
        generateAccessToken = token.toJwt();
        return token.toJwt();
    }



   void createConversation(String conversationName){

       System.out.println("sdkVersionName");
        String sdkVersionName = ConversationsClient.getSdkVersion();

        System.out.println(sdkVersionName);
       String accessToken = generateAccessToken;
        Properties properties = new Properties() {
            @Override
            public String getRegion() {
                return null;
            }

            @Override
            public boolean useProxy() {
                return false;
            }

            @Override
            public boolean getDeferCA() {
                return false;
            }

            @Override
            public int getCommandTimeout() {
                return 0;
            }
        };

        ConversationsClient conversationsClient;

       ConversationsClient.create(getApplicationContext(), accessToken, properties, new CallbackListener<ConversationsClient>() {
           @Override
           public void onSuccess(ConversationsClient client) {
               System.out.println("client11-"+client.getMyUser().toString());
               client.createConversation("conversation11",new CallbackListener<Conversation>(){

                   @Override
                   public void onSuccess(Conversation result) {
                       System.out.println("client11-"+result.getSid());
                   }

                   @Override
                   public void onError(ErrorInfo errorInfo) {
                       System.out.println("client11-"+errorInfo.getMessage());
                       CallbackListener.super.onError(errorInfo);
                   }
               });
           }

           @Override
           public void onError(ErrorInfo errorInfo) {
               System.out.println("client11"+errorInfo.getMessage());
           }

       });
   }

   void joinConversation(){
    }






}


