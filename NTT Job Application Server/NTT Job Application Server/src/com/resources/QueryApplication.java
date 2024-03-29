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
import model.Jobs;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.ApplicationsDao;
 


 
 
 @Path("/queryapplication")
 public class QueryApplication {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String queryapplication(String message) {
		 String device_id=null;
		 String job_ref_no=null;
		  
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try{
			JSONObject jsonObject=new JSONObject(message);
			if(jsonObject.has("device_id")){
			device_id=jsonObject.getString("device_id");
			}else{
				errorMessage="device_id is missing!";
			}
			
			if(jsonObject.has("job_ref_no")){
			job_ref_no=jsonObject.getString("job_ref_no");		
			} 
		 	} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		 	}
		 
    	  	 	
 		ApplicationsDao appDao=new ApplicationsDao();
 	    List<Applications> applications=new ArrayList<Applications>();
 		 
 	 
 		 
 		if(device_id!=null&&job_ref_no!=null)
 		{		  			 
 			 applications=appDao.queryApplications(device_id, job_ref_no);
 			     		 
 		}else if(device_id!=null&&job_ref_no==null){
 			
 			applications=appDao.queryApplications(device_id);
 		}
 		
 		
 		
 		if(applications!=null&&!applications.isEmpty()){
 		ObjectMapper mapper=new ObjectMapper();
 		StringWriter sw =new StringWriter();
 		
 		try {
			mapper.writeValue(sw, applications);
		} catch (JsonGenerationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonMappingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
 		System.out.println("stringwriter: "+sw); 
 		
 		responseMessage=sw.toString(); 	
 		}else if(applications==null){
 			 
 	 			responseMessage= "{\"resultIsEmpty\":true}"; 	
 	 		 
 		}
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}
 		return responseMessage;
     }
	 
 }