package com.resources;

import java.io.IOException;
import java.io.StringWriter;
import java.text.DecimalFormat;
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
import model.FilterSet;
import model.Jobs;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.ApplicationsDao;
import dao.FilterSetsDao;
import dao.JobsDao;


 
 
 @Path("/delete_filter_set")
 public class DeleteFilterSets {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String storeFilterSets(String message) {
		 String uuid=null;
	 
	 
		 Boolean isSuccessfulDeleted=null;
		  
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			if(jsonObject.has("uuid")){
				uuid=jsonObject.getString("uuid");
	 			}else{
	 				errorMessage+=" the parameter : uuid is missing! ";
	 			}
			 
 			 
 			
 			 
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		 
    	  FilterSetsDao filterSetsDao=new FilterSetsDao();
 		 
 		if(!uuid.equalsIgnoreCase("null"))
 		{
 				 
 				isSuccessfulDeleted=filterSetsDao.deleteFilterSet(uuid);
 				 
 				  
 					if(isSuccessfulDeleted==true){
 						 
 					
 						responseMessage= "{\"delete_filter_set_successful\":\"true\",\"uuid\":\""+uuid+"\"}"; 	  	
 					}
 				
 				else{
 					responseMessage="failed to delete filterSet, please try again";
 					} 		 
 		} 		
 		
 		else{			 
 			
 			 
 			
 			if(uuid.equalsIgnoreCase("null"))
				errorMessage+=" the parameter uuid can not be null! ";

 			 			 
 			}
				 			
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}
 		return responseMessage;
     }
	 
 }