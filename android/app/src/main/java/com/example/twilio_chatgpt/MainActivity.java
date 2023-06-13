package com.example.twilio_chatgpt;

import static com.twilio.conversations.ConversationsClient.*;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.twilio.conversations.Attributes;
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
    private MethodChannel.Result messageListResult;
    private MethodChannel.Result sendMessageResult;
    private MethodChannel.Result addParticipantResult;
    private MethodChannel.Result createConversationResult;
    private MethodChannel.Result authenticationResult;






    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                      (call, result) -> {


                          System.out.println("MethodChannel");
                          if(Objects.equals(call.method,"generateToken")){
                              authenticationResult = new MethodResultWrapper(result);
                              String accessToken = generateAccessToken(call.argument("accountSid"),call.argument("apiKey"),call.argument("apiSecret"),call.argument("identity"));
                              System.out.println("accessToken-"+accessToken);
                              init();
                              //result.success(accessToken);
                          }
                          if(Objects.equals(call.method, "createConversation")){
                              createConversationResult = new MethodResultWrapper(result);
                              createConversation(call.argument("conversationName"),call.argument("identity"));
                          }
                          if(Objects.equals(call.method, "sendMessage")){
                              sendMessageResult = new MethodResultWrapper(result);
                              sendMessages(call.argument("enteredMessage"),call.argument("conversationName"),call.argument("isFromChatGpt"));
                          }
                          if(Objects.equals(call.method, "joinConversation")){
                             String joinStatus =  joinConversation(call.argument("conversationName"));
                             result.success(joinStatus);
                          }
                          if(Objects.equals(call.method, "addParticipant")){
                              addParticipantResult = new MethodResultWrapper(result);
                              String addedStatus =  addParticipant(call.argument("participantName"),call.argument("conversationName"));
                              //result.success(addedStatus);
                          }
                          if(Objects.equals(call.method, "seeMyConversations")){
                              // joinConversation();
                              List<Map<String, Object>> conversationList = getConversationsList();
                            System.out.println("conversationList"+conversationList.toString());
                            result.success(conversationList);
                          }
                          if(Objects.equals(call.method,"getMessages")){
                              messageListResult = new MethodResultWrapper(result);
                              getAllMessages(call.argument("conversationName"));
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
                authenticationResult.success("Logged In");

            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                System.out.println("client12-" + errorInfo.getStatus()+"-"+errorInfo.getCode()+"-"+errorInfo.getMessage()+"-"+errorInfo.getDescription()+"-"+errorInfo.getReason());
                authenticationResult.success("Logged In Fail");

            }

        });
    }



    public String createConversation(String conversationName,String identity) {
        conversationClient.createConversation(conversationName, new CallbackListener<Conversation>() {

            @Override
            public void onSuccess(Conversation result) {
                System.out.println("client11-" + result.getSid());
                conversation = result;
                createConversationResult.success("Created Conversation Successfully");
                String added = addParticipant(identity, conversationName);
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                System.out.println("client11-" + errorInfo.getMessage());
                createConversationResult.success("Error While Creating Conversation");
                CallbackListener.super.onError(errorInfo);
            }
        });
        return "";
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
                        addParticipantResult.success("Added Successfully");
                        //List<Participant> participantList = conversation.getParticipantsList();
                        // System.out.println(participantList.toString());
                    }

                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        addParticipantResult.success("Error While Adding");
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

    public String sendMessages(String enteredMessage,String conversationName,boolean isFromChatGpt){

        conversationClient.getConversation(conversationName,new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                // Join the conversation with the given participant identity
                System.out.println("enteredMessage-" + result.getUniqueName());
                Attributes attributes = new Attributes(isFromChatGpt);
                result.prepareMessage()
                        .setAttributes(attributes)
                        .setBody(enteredMessage)
                        .buildAndSend(new CallbackListener() {


                            @Override
                            public void onSuccess(Object result) {
                                System.out.println("senddd");
                                receiveMessages();
                                sendMessageResult.success("send");

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


    public List<Map<String, Object>> getAllMessages(String conversationName){
        conversationClient.getConversation(conversationName,new CallbackListener<Conversation>(){

            @Override
            public void onSuccess(Conversation result) {
                result.getLastMessages(100, new CallbackListener<List<Message>>() {

                    @Override
                    public void onSuccess(List<Message> messagesList) {
                        List<Map<String, Object>> list = new ArrayList<>();
                        for (int i=0;i<messagesList.size();i++){
                            // Map conversationMap = new HashMap<>();
                            Map<String, Object> messagesMap = new HashMap<>();
                            messagesMap.put("sid",messagesList.get(i).getSid());
                            messagesMap.put("author",messagesList.get(i).getAuthor());
                            messagesMap.put("body",messagesList.get(i).getBody());
                            messagesMap.put("attributes",messagesList.get(i).getAttributes().toString());
                            messagesMap.put("dateCreated",messagesList.get(i).getDateCreated());
                            System.out.println("messagesMap-"+messagesList.get(i).getDateCreated());

                            list.add(messagesMap);

                        }
                        System.out.println(list);
                        messageListResult.success(list);
                    }

                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        // Error occurred while retrieving the messages
                        System.out.println("Error retrieving messages: " + errorInfo.getMessage());
                    }
                });
            }

            @Override
            public void onError(ErrorInfo errorInfo) {
                CallbackListener.super.onError(errorInfo);
            }
        });
        return null;
    }


    private static class MethodResultWrapper implements MethodChannel.Result {
        private final MethodChannel.Result methodResult;
        private boolean isResultSent = false;

        MethodResultWrapper(MethodChannel.Result result) {
            this.methodResult = result;
            //handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {
            if (!isResultSent) {
                methodResult.success(result);
                isResultSent = true;
            }
        }

        @Override
        public void error(
                @NonNull final String errorCode, final String errorMessage, final Object errorDetails) {
            if (!isResultSent) {
                methodResult.error(errorCode, errorMessage, errorDetails);
                isResultSent = true;
            }
        }

        @Override
        public void notImplemented() {
            if (!isResultSent) {
                methodResult.notImplemented();
                isResultSent = true;
            }
        }
    }
}






