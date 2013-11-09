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


 
 
 @Path("/query_filter_set")
 public class QueryFilterSets {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String storeFilterSets(String message) {
		  
		 String device_id=null;
		  
		 
	 
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
 			 
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		 
    	  FilterSetsDao filterSetsDao=new FilterSetsDao();
 		 
 		if(!device_id.equalsIgnoreCase("null"))
 		{
 				 
 				List<FilterSet> filterSets=new ArrayList<FilterSet>();
 				filterSets=filterSetsDao.queryFilterSetsbyDeviceID(device_id);
 				
 				 
 		if(filterSets!=null&&!filterSets.isEmpty()){
 		ObjectMapper mapper=new ObjectMapper();
 		StringWriter sw =new StringWriter();
 		
 		try {
			mapper.writeValue(sw, filterSets);
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
 		}
 		
 		else if(filterSets==null){
 			 
 	 			responseMessage= "{\"resultIsEmpty\":true}"; 	
 	 		 
 		}
 		}
 		else if(device_id.equalsIgnoreCase("null")){
 			errorMessage+=" the parameter device_id can't be null! ";
 		}
 		
 		
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}
 		return responseMessage;
     }
	 
 }