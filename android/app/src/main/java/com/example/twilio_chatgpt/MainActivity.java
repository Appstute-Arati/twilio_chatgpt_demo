package com.example.twilio_chatgpt;

import static com.twilio.conversations.ConversationsClient.*;

import androidx.annotation.NonNull;

import com.twilio.conversations.CallbackListener;
import com.twilio.conversations.Conversation;
import com.twilio.conversations.ConversationListener;
import com.twilio.conversations.ConversationsClient;
import com.twilio.conversations.ConversationsClientListener;
import com.twilio.conversations.Message;
import com.twilio.conversations.Participant;
import com.twilio.conversations.StatusListener;
import com.twilio.conversations.User;
import com.twilio.jwt.accesstoken.AccessToken;
import com.twilio.jwt.accesstoken.ChatGrant;




import com.twilio.util.ErrorInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;




public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "twilio_chatgpt/twilio_sdk_connection";
    private static String generateAccessToken;
    private ConversationsClient conversationClient;
    private Conversation conversation;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                      (call, result) -> {
                          System.out.println("MethodChannel");
                          if(Objects.equals(call.method,"generateToken")){
                              String accessToken = generateAccessToken(call.argument("accountSid"),call.argument("apiKey"),call.argument("apiSecret"),call.argument("identity"));
                              System.out.println("accessToken-"+accessToken);
                              init();
                              result.success(accessToken);
                          }
                          if(Objects.equals(call.method, "createConversation")){
                               createConversation(call.argument("conversationName"),call.argument("identity"));

                          }
                          if(Objects.equals(call.method, "sendMessage")){
                              sendMessages(call.argument("enteredMessage"),call.argument("conversationName"));
                          }
                          if(Objects.equals(call.method, "joinConversation")){
                             String joinStatus =  joinConversation(call.argument("conversationName"));
                             result.success(joinStatus);
                          }
                          if(Objects.equals(call.method, "addParticipant")){
                              String addedStatus =  addParticipant(call.argument("participantName"),call.argument("conversationName"));
                              result.success(addedStatus);
                          }
                          if(Objects.equals(call.method, "seeMyConversations")){
                              // joinConversation();
                              List<Map<String, Object>> conversationList = getConversationsList();
                            System.out.println("conversationList"+conversationList.toString());
                            result.success(conversationList);
                          }


        });
    }


    public static String generateAccessToken(String accountSid, String apiKey, String apiSecret, String identity) {
        // Create an AccessToken builder
        AccessToken.Builder builder = new AccessToken.Builder(accountSid, apiKey, apiSecret);
        // Set the identity of the token
        builder.identity(identity);
        // Create a Chat grant and add it to the token
        ChatGrant chatGrant = new ChatGrant();
        chatGrant.setServiceSid("IS1b4142e65b0f482fb795e2c48d028f45");
        builder.grant(chatGrant);

        // Build the token
        AccessToken token = builder.build();
        generateAccessToken = token.toJwt();


        return token.toJwt();


    }

    void init(){
        System.out.println("sdkVersionName");
        String sdkVersionName = getSdkVersion();

        System.out.println(sdkVersionName);
        String accessToken = generateAccessToken;

        ConversationsClient.Properties props = ConversationsClient.Properties.newBuilder().createProperties();
        ConversationsClient.create(getApplicationContext(), accessToken, props, new CallbackListener<ConversationsClient>() {
            @Override
            public void onSuccess(ConversationsClient client) {
                System.out.println("client11-" + client.getMyIdentity().toString());
                conversationClient = client;
              //  createConversation("");


            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
            }

        });
    }



   void createConversation(String conversationName,String identity){
        conversationClient.createConversation(conversationName, new CallbackListener<Conversation>() {

           @Override
           public void onSuccess(Conversation result) {
               System.out.println("client11-" + result.getSid());
               conversation = result;
              String added =  addParticipant(identity,conversationName);
           }

           @Override
           public void onError(ErrorInfo errorInfo) {
               System.out.println("client11-" + errorInfo.getMessage());
               CallbackListener.super.onError(errorInfo);
           }
       });
    }

    public String addParticipant(String participantName,String conversationName){

        conversationClient.getConversation(conversationName,new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                // Retrieve the conversation object using the conversation SID
                result.addParticipantByIdentity(participantName,null,new StatusListener() {
                    @Override
                    public void onSuccess() {
                        System.out.println("added successfully");
                        //List<Participant> participantList = conversation.getParticipantsList();
                        // System.out.println(participantList.toString());
                    }

                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        // List<Participant> participantList = conversation.getParticipantsList();
                        // System.out.println(participantList.toString());
                        System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
                        StatusListener.super.onError(errorInfo);
                    }
                });

            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });


        return "added";

   }

   public String joinConversation(String conversationName){
        conversationClient.getConversation(conversationName,new CallbackListener<Conversation>(){

           @Override
           public void onSuccess(Conversation result) {
               // Retrieve the conversation object using the conversation SID
               result.join(new StatusListener() {

                   @Override
                   public void onSuccess() {
                         System.out.println("joined");
                         receiveMessages();
                        // sendMessages();
                   }
                   @Override
                   public void onError(ErrorInfo errorInfo) {
                       System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

                       StatusListener.super.onError(errorInfo);
                   }
               });

           }

           @Override
           public void onError(ErrorInfo errorInfo) {
               CallbackListener.super.onError(errorInfo);
           }
       });
       return conversationName;
    }

    public String sendMessages(String enteredMessage,String conversationName){

        conversationClient.getConversation(conversationName,new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                // Join the conversation with the given participant identity
                System.out.println("enteredMessage-" + result.getUniqueName());
                result.prepareMessage()
                        .setBody(enteredMessage)
                        .buildAndSend(new CallbackListener() {


                            @Override
                            public void onSuccess(Object result) {
                                System.out.println("senddd");
                                receiveMessages();

                            }

                            @Override
                            public void onError(ErrorInfo errorInfo) {
                                System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

                            }
                        });
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
        return "send";
    }

    void receiveMessages(){
        conversationClient.getConversation("CH122e85471f6a44ac8ebbec124cce5f0b",new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                // Retrieve the conversation object using the conversation SID

                // Join the conversation with the given participant identity
                result.addListener(new ConversationListener() {
                    @Override
                    public void onMessageAdded(Message message) {
                        System.out.println("message"+message.getBody());

                        System.out.println("message"+message.getParticipant().getSid());
                    }

                    @Override
                    public void onMessageUpdated(Message message, Message.UpdateReason reason) {

                    }

                    @Override
                    public void onMessageDeleted(Message message) {

                    }

                    @Override
                    public void onParticipantAdded(Participant participant) {

                    }

                    @Override
                    public void onParticipantUpdated(Participant participant, Participant.UpdateReason reason) {

                    }


                    @Override
                    public void onParticipantDeleted(Participant participant) {

                    }

                    @Override
                    public void onTypingStarted(Conversation conversation, Participant participant) {

                    }

                    @Override
                    public void onTypingEnded(Conversation conversation, Participant participant) {

                    }

                    @Override
                    public void onSynchronizationChanged(Conversation conversation) {

                    }
                });
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());

                CallbackListener.super.onError(errorInfo);
            }
        });
    }

    void getParticipantList(){
        conversationClient.getConversation("CH122e85471f6a44ac8ebbec124cce5f0b",new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                // Retrieve the conversation object using the conversation SID

                // Join the conversation with the given participant identity
                List<Participant> participantList = result.getParticipantsList();
                for (int i=0;i<participantList.size();i++){
                    System.out.println(participantList.get(i).getIdentity());
                }
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });

    }

    public List<Map<String, Object>> getConversationsList(){
        List<Conversation> conversationList = conversationClient.getMyConversations();
        System.out.println(conversationList.size()+"");
        Map conversation = new HashMap();
        List<Map<String, Object>> list = new ArrayList<>();

        for (int i=0;i<conversationList.size();i++){
           // Map conversationMap = new HashMap<>();
            Map<String, Object> conversationMap = new HashMap<>();
            conversationMap.put("sid",conversationList.get(i).getSid());
            conversationMap.put("conversationName",conversationList.get(i).getFriendlyName());
            list.add(conversationMap);
        }

        return  list;

    }















}



