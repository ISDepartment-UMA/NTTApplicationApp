package com.resources;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import model.Applications;
import model.FAQrates;
import model.Jobs;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.ApplicationsDao;
import dao.JobsDao;


 
 
 @Path("/ratefaq")
 public class RateFAQ {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String applyJobs(String message) {
		 String device_id=null;
		 String faq_no=null;
		 String score=null;						 
	 
		 Boolean isSuccessfulInserted=null;
		  
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			 
 			if(jsonObject.has("device_id")){
			device_id=jsonObject.getString("device_id");
 			}else{
 				errorMessage+=" the parameter : device_id is missing! ";
 			}
 			
 			if(jsonObject.has("faq_no")){
 				faq_no=jsonObject.getString("faq_no");
 			}else{
			errorMessage+=" the parameter : faq_no is missing! ";
			}
 			
 			if(jsonObject.has("score")){
 				score=jsonObject.getString("score");}
 			else{ 		
			errorMessage+=" the parameter : score is missing! ";}
 			
 			 
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		 
    	  	 	
 		ApplicationsDao appDao=new ApplicationsDao();
 		 
 		
 		 
 	 
 		 
 		if(device_id!=null&&faq_no!=null&&score!=null)
 		{
 				if(appDao.checkRepeatRating(device_id,faq_no)==false)
 				
 				{   //means the user hasn't applied for this job
 			
 			    Applications application =new Applications();
 			    FAQrates faqrates =new FAQrates();
 			    faqrates.setDevice_id(device_id);
 			    faqrates.setFaq_no(faq_no);
 			    faqrates.setScore(score);
 				 
 			 
 				isSuccessfulInserted=appDao.insertFAQRates(faqrates);
 			  
 					if(isSuccessfulInserted==true)
 					responseMessage= "{\"faqrates_successful\":\"true\",\"device_id\":\""+device_id+"\",\"faq_no\":\""+faq_no+"\"}"; 	  			  
 				}
 				else{
 					responseMessage="the user already rated this question, please don't rate again";
 				} 		 
 		} 		
 		
 		else{			 
 			
 			if(device_id==null)
 				errorMessage+=" the parameter device_id can not be null! ";
 			
 			if(faq_no==null)
				errorMessage+=" the parameter faq_no can not be null! ";

 			if(score==null)
				errorMessage+=" the parameter score can not be null! "; 			 
 			}
				 			
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}
 		return responseMessage;
     }
	 
 }