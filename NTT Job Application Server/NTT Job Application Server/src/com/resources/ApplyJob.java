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
import dao.JobsDao;


 
 
 @Path("/applyjob")
 public class ApplyJob {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String applyJobs(String message) {
		 String device_id=null;
		 String job_ref_no=null;
		 String apply_time=null;
		 String application_status=null;
		 String email=null;
		 String first_name=null;
		 String last_name=null;
		 String address=null;
		 String phone_no=null;
				 
		 Boolean refNOIsValid=null;
		 Boolean isSuccessfulInserted=null;
		  
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			device_id=jsonObject.getString("device_id");
			job_ref_no=jsonObject.getString("job_ref_no");
			apply_time=jsonObject.getString("apply_time");
			application_status=jsonObject.getString("application_status");
			email=jsonObject.getString("email");
			first_name=jsonObject.getString("first_name");
			last_name=jsonObject.getString("last_name");
			address=jsonObject.getString("address");
			phone_no=jsonObject.getString("phone_no");
			 
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 
    	  	 	
 		ApplicationsDao appDao=new ApplicationsDao();
 		 
 		
 		refNOIsValid=appDao.checkRefNOInput(job_ref_no);
 	 
 		 
 		if(refNOIsValid==true&&
 				device_id!=null&&
 				job_ref_no!=null&&
 				apply_time!=null&&
 				application_status!=null&&
 				email!=null&&
 				first_name!=null&&
 				last_name!=null&&
 				address!=null&&
 				phone_no!=null 				
 				)
 		{
 				if(appDao.checkRepeatApply(job_ref_no,device_id)==false)
 				
 				{   //means the user hasn't applied for this job
 			
 			    Applications application =new Applications();
 			 
 				application.setDevice_id(device_id);
 				application.setJob_ref_no(job_ref_no);
 				application.setApply_time(apply_time);
 				application.setApplicaton_status(application_status);
 				application.setEmail(email);
 				application.setFirst_name(first_name);
 				application.setLast_name(last_name);
 				application.setAddress(address);
 				application.setPhone_no(phone_no);
 			 
 				isSuccessfulInserted=appDao.insertApplications(application);
 			  
 					if(isSuccessfulInserted==true)
 					responseMessage= "{\"applyingJob_successful\":true}"; 	 
 			  
 			  
 				}
 				else{
 					responseMessage="the user already applyed this job, please don't apply again";
 				}
 		
 		 
 		
 		 		
 		 
 		} 		
 		
 		else{
 			if(refNOIsValid==false){
 				errorMessage+="the parameter : job_ref_no "+ job_ref_no  +" is wrong, please check again";
 			}
 			if(device_id==null){
 				errorMessage+="the parameter : device_id is missing!";
 			}
 			if(job_ref_no==null){
 				errorMessage+="the parameter : job_ref_no is missing!";
 			}
 			if(apply_time==null){
 				errorMessage+="the parameter : apply_time is missing!";
 			}
 			if(application_status==null){
 				errorMessage+="the parameter : application_status is missing!";
 			}
 			if(email==null){
 				errorMessage+="the parameter : email is missing!";
 			}
 			if(first_name==null){
 				errorMessage+="the parameter : first_name is missing!";
 			}
 			if(last_name==null){
 				errorMessage+="the parameter : last_name is missing!";
 			}
 			if(address==null){
 				errorMessage+="the parameter : address is missing!";
 			}
 			if(phone_no==null){
 				errorMessage+="the parameter : phone_no is missing!";
 			}
 			
 			 
 			responseMessage=errorMessage;
 			
 		}
 		
 		
 		return responseMessage;
     }
	 
 }