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
import model.SpeculativeApplication;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.ApplicationsDao;
import dao.JobsDao;




@Path("/apply_speculative_application")
public class ApplySpeculativeApplication {


	@POST      
	@Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
	public String applyJobs(String message) {
		String uuid=null;
		String device_id=null;		 
		String apply_time=null;
		String application_status=null;
		String email=null;
		String first_name=null;
		String last_name=null;
		String address=null;
		String phone_no=null;
		String dropbox_url=null;
		String freetext=null;				 

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

			if(jsonObject.has("apply_time")){
				apply_time=jsonObject.getString("apply_time");}
			else{ 		
				errorMessage+=" the parameter : apply_time is missing! ";}

			if(jsonObject.has("application_status")){
				application_status=jsonObject.getString("application_status");}
			else{
				errorMessage+=" the parameter : application_status is missing! ";}

			if(jsonObject.has("email")){
				email=jsonObject.getString("email");}
			else{
				errorMessage+=" the parameter : email is missing! ";}

			if(jsonObject.has("first_name")){ 	 
				first_name=jsonObject.getString("first_name");}
			else{ 
				errorMessage+=" the parameter : first_name is missing! ";}

			if(jsonObject.has("last_name")){
				last_name=jsonObject.getString("last_name");}
			else{
				errorMessage+=" the parameter : last_name is missing! ";}

			if(jsonObject.has("address")){
				address=jsonObject.getString("address");}
			else{
				errorMessage+=" the parameter : address is missing! ";}

			if(jsonObject.has("phone_no")){
				phone_no=jsonObject.getString("phone_no");}
			else{
				errorMessage+=" the parameter : phone_no is missing! ";}

			if(jsonObject.has("dropbox_url")){
				dropbox_url=jsonObject.getString("dropbox_url");}
			else{
				errorMessage+=" the parameter : dropbox_url is missing! ";}

			if(jsonObject.has("freetext")){
				freetext=jsonObject.getString("freetext");}
			else{
				errorMessage+=" the parameter : freetext is missing! ";}

		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}


		ApplicationsDao appDao=new ApplicationsDao();


		if( 	uuid!=null&&
				device_id!=null&& 				 
				apply_time!=null&&
				application_status!=null&&
				email!=null&&
				first_name!=null&&
				last_name!=null&&
				address!=null&&
				phone_no!=null&&
				dropbox_url!=null
				)
		{
			if(appDao.checkRepeatSpecApply(device_id)==false){   //means the user hasn't applied for this job

				SpeculativeApplication application=new SpeculativeApplication();

				application.setUuid(uuid);
				application.setDevice_id(device_id); 				
				application.setApply_time(apply_time); 			 
				application.setApplication_status(application_status);
				application.setEmail(email);
				application.setFirst_name(first_name);
				application.setLast_name(last_name);
				application.setAddress(address);
				application.setPhone_no(phone_no);
				application.setDropbox_url(dropbox_url);
				application.setFreetext(freetext);

				isSuccessfulInserted=appDao.insertSpecApplications(application);

				if(isSuccessfulInserted==true)
					responseMessage= "{\"applyingJob_successful\":\"true\",\"device_id\":\""+device_id+"\",\"uuid\":\""+uuid+"\"}"; 	  	

			}
			else{
				responseMessage="the user already applyed this job, please don't apply again";
			} 	
		}


			else{
				if(uuid==null)
					errorMessage+="the parameter uuid can not be null! ";

				if(device_id==null)
					errorMessage+=" the parameter device_id can not be null! ";

				if(apply_time==null)
					errorMessage+=" the parameter apply_time can not be null! ";

				if(application_status==null)
					errorMessage+=" the parameter application_status can not be null! ";

				if(email==null)
					errorMessage+=" the parameter email can not be null! ";

				if(first_name==null)
					errorMessage+=" the parameter first_name can not be null! ";

				if(last_name==null)
					errorMessage+=" the parameter last_name can not be null! ";

				if(address==null)
					errorMessage+=" the parameter address can not be null! ";

				if(phone_no==null)
					errorMessage+=" the parameter phone_no can not be null! "; 			

				if(dropbox_url==null)
					errorMessage+=" the parameter dropbox_url can not be null! ";


			}



			if(!errorMessage.isEmpty()){
				responseMessage=errorMessage;
			}
			return responseMessage;
		}

	}