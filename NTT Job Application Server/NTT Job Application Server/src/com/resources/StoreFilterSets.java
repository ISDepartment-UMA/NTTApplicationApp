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


 
 
 @Path("/store_filter_set")
 public class StoreFilterSets {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String storeFilterSets(String message) {
		 String uuid=null;
		 String device_id=null;
		 String job_title=null;
		 String location=null;
		 String topic=null;
		 String exp=null;
		 
	 
		 Boolean isSuccessfulInserted=null;
		  
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
			 
 			if(jsonObject.has("device_id")){
			device_id=jsonObject.getString("device_id");
 			}else{
 				errorMessage+=" the parameter : device_id is missing! ";
 			}
 			
 			if(jsonObject.has("job_title")){
 				job_title=jsonObject.getString("job_title");
 			}else{
			errorMessage+=" the parameter : job_title is missing! ";
			}
 			
 			if(jsonObject.has("location")){
 				location=jsonObject.getString("location");}
 			else{ 		
			errorMessage+=" the parameter : location is missing! ";}
 			
 			if(jsonObject.has("topic")){
 				topic=jsonObject.getString("topic");}
 			else{ 		
			errorMessage+=" the parameter : topic is missing! ";}
 			
 			if(jsonObject.has("exp")){
 				exp=jsonObject.getString("exp");}
 			else{ 		
			errorMessage+=" the parameter : exp is missing! ";}
 			
 			 
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		 
    	  FilterSetsDao filterSetsDao=new FilterSetsDao();
 		 
 		if(uuid!=null&device_id!=null)
 		{
 				FilterSet filterSet=new FilterSet();
 				filterSet.setUuid(uuid);
 				filterSet.setDevice_id(device_id);
 				filterSet.setJob_title(job_title);
 				filterSet.setLocation(location);
 				filterSet.setTopic(topic);
 				filterSet.setExp(exp);
 			      
 				isSuccessfulInserted=filterSetsDao.insertFilterSet(filterSet);
 				  
 					if(isSuccessfulInserted==true){
 						 
 					
 						responseMessage= "{\"store_filter_set_successful\":\"true\",\"device_id\":\""+device_id+"\",\"uuid\":\""+uuid+"\"}"; 	  	
 					}
 				
 				else{
 					responseMessage="failed tostore filterSets, please try again";
 					} 		 
 		} 		
 		
 		else{			 
 			
 			if(device_id==null)
 				errorMessage+=" the parameter device_id can not be null! ";
 			
 			if(uuid==null)
				errorMessage+=" the parameter uuid can not be null! ";

 			 			 
 			}
				 			
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}
 		return responseMessage;
     }
	 
 }