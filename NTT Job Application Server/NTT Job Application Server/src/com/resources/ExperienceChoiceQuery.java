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

import model.Experience;
import model.Jobs;
import model.Jobtitle;
import model.Locations;
import model.Topics;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.CriterionChoiceDao;
import dao.JobsDao;


 
 
 @Path("/experiencechoicequery")
 public class ExperienceChoiceQuery {
	 String errorMessage="";
	 String responseMessage=null; 
	 

	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String returnExperienceChoice() {		 
		 
    	 List<Experience> myExperience=new ArrayList<Experience>();
    //	 List<Jobtitle> myJobtitle=new ArrayList<Jobtitle>();
    //	 List<Locations> myLocations=new ArrayList<Locations>();
    //	 List<Topics> myTopics=new ArrayList<Topics>();
 		CriterionChoiceDao criterionChoiceDao=new CriterionChoiceDao();
 		 
 		 myExperience=criterionChoiceDao.queryExperienceChoice();
 	//   	 myJobtitle=criterionChoiceDao.queryJobtitleChoice();
 	//	 myLocations=criterionChoiceDao.queryLocationsChoice();
 	//	 myTopics=criterionChoiceDao.queryTopicsChoice();
 		  		
 		 
 		 
 		ObjectMapper mapper=new ObjectMapper();
 		StringWriter sw =new StringWriter();
 		
 		try {
			mapper.writeValue(sw, myExperience);
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
 		
 		return responseMessage;
     }
	 
 }