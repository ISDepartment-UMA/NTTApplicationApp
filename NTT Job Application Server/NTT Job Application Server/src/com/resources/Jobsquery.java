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

import model.Jobs;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.JobsDao;


 
 
 @Path("/fixedjobsquery")
 public class Jobsquery {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String returnJobs(String message) {
		 String location=null;
		 String topic=null;
		 String jobtitle=null;
		 String exp=null;
		 Boolean locationIsValid=null;
		 Boolean topicIsValid=null;
		 Boolean jobtitleIsValid=null;
		 Boolean expIsValid=null;
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			location=jsonObject.getString("location");
			topic=jsonObject.getString("topic");
			jobtitle=jsonObject.getString("jobtitle");
			exp=jsonObject.getString("exp");
			System.out.println("location: "+location);
			System.out.println("topic : "+topic);
			System.out.println("jobtitle: "+jobtitle);
			System.out.println("exp: "+exp);
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 
    	 List<Jobs> myjobs=new ArrayList<Jobs>();
 		JobsDao myJobsDao=new JobsDao(); 	
 		 
 		
 		locationIsValid=myJobsDao.checkLocationInput(location);
 		topicIsValid=myJobsDao.checkTopicsInput(topic);
 		jobtitleIsValid=myJobsDao.checkJobTitleInput(jobtitle);
 		expIsValid=myJobsDao.checkExpInput(exp);
 		 
 		if(locationIsValid==true&&topicIsValid==true&&jobtitleIsValid==true&&expIsValid==true){
 		
 			myjobs=myJobsDao.queryJobsByDefinedCriteria(jobtitle, location, topic, exp);
 		
 		
 			if(myjobs==null){
 			
 			System.out.println("{\"resultIsEmpty\":true}");
 			responseMessage= "{\"resultIsEmpty\":true}"; 			
 			}
 		
 		else{
 		for(int i=0;i<=myjobs.size()-1;i++)
		{		 
		System.out.println("search results:"+myjobs.get(i).getRef_no()+"/////location: "+myjobs.get(i).getLocation1()+","+myjobs.get(i).getLocation2()+","+myjobs.get(i).getLocation3()+","+myjobs.get(i).getLocation4()
				+"/////jobtitle: "+myjobs.get(i).getJob_title()+"/////exp: "+myjobs.get(i).getExp()+"//////topics: "+myjobs.get(i).getTopic1()+","+myjobs.get(i).getTopic2()+","+myjobs.get(i).getTopic3()+","+myjobs.get(i).getTopic4());
		}
 		ObjectMapper mapper=new ObjectMapper();
 		StringWriter sw =new StringWriter();
 		
 		try {
			mapper.writeValue(sw, myjobs);
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
 		//if(sw.toString().isEmpty()){
 			//return null;
 		//}
 		
 		responseMessage=sw.toString();
 		}
 		
 		
 		
 			}else{
 			if(locationIsValid==false){
 				errorMessage+="the parameter location: "+location +" is wrong, please check again";
 			}
 			if(topicIsValid==false){
 				errorMessage+="the parameter topic: "+topic+ " is wrong, please check again";
 			}
 			if(jobtitleIsValid==false){
 				errorMessage+="the parameter jobtitle: "+jobtitle+ " is wrong, please check again";
 			}
 			if(expIsValid==false){
 				errorMessage+="the parameter exp: "+exp+ " is wrong, please check again";
 			}
 			
 			responseMessage=errorMessage;
 			
 		}
 		
 		
 		return responseMessage;
     }
	 
 }