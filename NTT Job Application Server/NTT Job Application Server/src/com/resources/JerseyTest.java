package com.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


 
 // The Java class will be hosted at the URI path "/helloworld"
 @Path("/helloworld")
 public class JerseyTest {
 
	 
     // The Java method will process HTTP GET requests
     @GET
     // The Java method will produce content identified by the MIME Media
     // type "text/plain"
     @Produces("text/plain")
     public String getClichedMessage() {
         // Return some cliched textual content
         return "this is hello world response from Jersey!";
     }
     
	 
 }