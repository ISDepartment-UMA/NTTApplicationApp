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
 


 
 
 @Path("/deleteapplication")
 public class DeleteApplication {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String deleteapplication(String message) {
		 String device_id=null;
		 String job_ref_no=null;
		 
				 
		 Boolean refNOIsValid=null;
		 Boolean isSuccessfulDeleted=null;
		  
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			device_id=jsonObject.getString("device_id");
			job_ref_no=jsonObject.getString("job_ref_no");
		 
			 
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 
    	  	 	
 		ApplicationsDao appDao=new ApplicationsDao();
 		 
 		
 		refNOIsValid=appDao.checkRefNOInput(job_ref_no);
 	 
 		 
 		if(refNOIsValid==true&&
 				device_id!=null&&
 				job_ref_no!=null		 		
 				)
 		{		 
 			 
 			isSuccessfulDeleted=appDao.deleteApplications(device_id,job_ref_no);
 			  
 					if(isSuccessfulDeleted==true)
 					responseMessage= "{\"deleteapplication_successful\":true}"; 	  		 
 		} 		
 		
 		else{
 			if(refNOIsValid==false){
 				errorMessage+="the parameter : job_ref_no "+ job_ref_no  +" is wrong, please check again";
 			}
 			if(device_id==null){
 				errorMessage+="the parameter : device_id is missing!";
 			}
 			 
 			responseMessage=errorMessage;
 			
 		}
 		
 		
 		return responseMessage;
     }
	 
 }