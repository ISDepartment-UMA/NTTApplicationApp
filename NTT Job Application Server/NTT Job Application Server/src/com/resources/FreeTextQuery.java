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
import model.SearchHits;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.JobsDao;


 
 
 @Path("/freetextquery")
 public class FreeTextQuery {
	 
	 
	 @POST      
     @Consumes({MediaType.TEXT_PLAIN,MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
     public String returnJobs(String message) {
		 String freetext=null;		 
		 String errorMessage="";
		 String responseMessage=null;
		 
		 
		 System.out.println("posted string:"+message);
		 
		 try {
			JSONObject jsonObject=new JSONObject(message);
			if(jsonObject.has("freetext")){
			freetext=jsonObject.getString("freetext");}
			else{
				errorMessage+=" freetext parameter is missing! ";
			}
			System.out.println("freetext: "+freetext);
			 
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 
		if(freetext!=null){
    	 List<Jobs> myjobs=new ArrayList<Jobs>();
 		JobsDao myJobsDao=new JobsDao(); 	
 		List<SearchHits> searchHitsList=new ArrayList<SearchHits>();
 		 
 		 /////DAO method
 		List<String> freetextList=new ArrayList<String>();
 		String freetextelementsArray[]=new String[50];
 		freetextelementsArray=freetext.split(" ");
 		for(int i=0;i<=freetextelementsArray.length-1;i++){          // to make user's input lower case
 			freetextelementsArray[i]=freetextelementsArray[i].toLowerCase();
 		}
 	
 		myjobs=myJobsDao.queryJobsByDefinedCriteria(null, null, null, null); //get all jobs
 		for(int i=0;i<=myjobs.size()-1;i++){          // iterate all the jobs
 			
 			///////////////////////////////////////////////////////////////////
 			//    to make the text in database into lower case to match with the user input
 			if(myjobs.get(i).getRef_no()!=null)
 			myjobs.get(i).setRef_no(myjobs.get(i).getRef_no().toLowerCase());
 			if(myjobs.get(i).getPosition_name()!=null)
 			myjobs.get(i).setPosition_name(myjobs.get(i).getPosition_name().toLowerCase());
 			if(myjobs.get(i).getExp()!=null)
 			myjobs.get(i).setExp(myjobs.get(i).getExp().toLowerCase());
 			if(myjobs.get(i).getLocation1()!=null)
 			myjobs.get(i).setLocation1(myjobs.get(i).getLocation1().toLowerCase());
 			if(myjobs.get(i).getLocation2()!=null)
 			myjobs.get(i).setLocation2(myjobs.get(i).getLocation2().toLowerCase());
 			if(myjobs.get(i).getLocation3()!=null)
 			myjobs.get(i).setLocation3(myjobs.get(i).getLocation3().toLowerCase());
 			if(myjobs.get(i).getLocation4()!=null)
 			myjobs.get(i).setLocation4(myjobs.get(i).getLocation4().toLowerCase());
 			if(myjobs.get(i).getJob_title()!=null)
 			myjobs.get(i).setJob_title(myjobs.get(i).getJob_title().toLowerCase());
 			if(myjobs.get(i).getTopic1()!=null)
 			myjobs.get(i).setTopic1(myjobs.get(i).getTopic1().toLowerCase());
 			if(myjobs.get(i).getTopic2()!=null)
 			myjobs.get(i).setTopic2(myjobs.get(i).getTopic2().toLowerCase());
 			if(myjobs.get(i).getTopic3()!=null)
 			myjobs.get(i).setTopic3(myjobs.get(i).getTopic3().toLowerCase());
 			if(myjobs.get(i).getTopic4()!=null)
 			myjobs.get(i).setTopic4(myjobs.get(i).getTopic4().toLowerCase());
 			if(myjobs.get(i).getContact_person()!=null)
 			myjobs.get(i).setContact_person(myjobs.get(i).getContact_person().toLowerCase());
 			if(myjobs.get(i).getPhone_no()!=null)
 			myjobs.get(i).setPhone_no(myjobs.get(i).getPhone_no().toLowerCase());
 			if(myjobs.get(i).getEmail()!=null)
 			myjobs.get(i).setEmail(myjobs.get(i).getEmail().toLowerCase());
 			if(myjobs.get(i).getJob_description()!=null)
 			myjobs.get(i).setJob_description(myjobs.get(i).getJob_description().toLowerCase());
 			if(myjobs.get(i).getMain_tasks()!=null)
 			myjobs.get(i).setMain_tasks(myjobs.get(i).getMain_tasks().toLowerCase());
 			if(myjobs.get(i).getJob_requirements()!=null)
 			myjobs.get(i).setJob_requirements(myjobs.get(i).getJob_requirements().toLowerCase());
 			if(myjobs.get(i).getPerspective()!=null)
 			myjobs.get(i).setPerspective(myjobs.get(i).getPerspective().toLowerCase());
 			if(myjobs.get(i).getOur_offer()!=null)
 			myjobs.get(i).setOur_offer(myjobs.get(i).getOur_offer().toLowerCase());
 			///////////////////////////////////////////////////////////////////
 			SearchHits searchHits=new SearchHits();            //create hit records for each job
 			searchHits.setRef_no(myjobs.get(i).getRef_no());
 			searchHits.setHits(0);
 			searchHitsList.add(i, searchHits);
 			for(int j=0;j<=freetextelementsArray.length-1;j++){       //iterate all the free text elements
 				if(myjobs.get(i).getRef_no()!=null&&myjobs.get(i).getRef_no().contains(freetextelementsArray[j])){    //ref_no hits
 				int hits=searchHits.getHits();
 				hits+=7;     // ref_no weights 7, because it's importance, and to make sure it ranked in the head
 				searchHits.setHits(hits);
 				}
 				
 				if(myjobs.get(i).getPosition_name()!=null&&myjobs.get(i).getPosition_name().contains(freetextelementsArray[j])){    //posotion_name hits
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getExp()!=null&&myjobs.get(i).getExp().contains(freetextelementsArray[j])){    //exp hits
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getLocation1()!=null&&myjobs.get(i).getLocation1().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getLocation2()!=null&&myjobs.get(i).getLocation2().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getLocation3()!=null&&myjobs.get(i).getLocation3().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getLocation4()!=null&&myjobs.get(i).getLocation4().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getJob_title()!=null&&myjobs.get(i).getJob_title().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getTopic1()!=null&&myjobs.get(i).getTopic1().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getTopic2()!=null&&myjobs.get(i).getTopic2().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getTopic3()!=null&&myjobs.get(i).getTopic3().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getTopic4()!=null&&myjobs.get(i).getTopic4().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				
 				if(myjobs.get(i).getContact_person()!=null&&myjobs.get(i).getContact_person().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getPhone_no()!=null&&myjobs.get(i).getPhone_no().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getEmail()!=null&&myjobs.get(i).getEmail().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getJob_description()!=null&&myjobs.get(i).getJob_description().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getMain_tasks()!=null&&myjobs.get(i).getMain_tasks().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getJob_requirements()!=null&&myjobs.get(i).getJob_requirements().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getPerspective()!=null&&myjobs.get(i).getPerspective().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				if(myjobs.get(i).getOur_offer()!=null&&myjobs.get(i).getOur_offer().contains(freetextelementsArray[j])){    
 	 				int hits=searchHits.getHits();
 	 				hits++;
 	 				searchHits.setHits(hits);
 	 				}
 				
 			}
 			
 			
 		}
 		
 		for(int i=0;i<searchHitsList.size()-1;i++){			//sorting the searchHItsList
 			for(int j=0;j<searchHitsList.size()-i-1;j++){
 				if(searchHitsList.get(j).getHits()<searchHitsList.get(j+1).getHits()){
 					SearchHits tempSearchHits=new SearchHits();
 					tempSearchHits=searchHitsList.get(j);
 					searchHitsList.set(j, searchHitsList.get(j+1));
 					searchHitsList.set(j+1, tempSearchHits);
 					
 				}
 				
 			}
 		}
 		
 		List<Jobs> queryResultJobs=new ArrayList<Jobs>();
 
 		for(int i=0;i<=searchHitsList.size()-1;i++){				
 			 //put the jobs in searchHitsList into queryResultJobs
 			if(searchHitsList.get(i).getHits()>0)
 			queryResultJobs.add(myJobsDao.jobsQueryByRefID(searchHitsList.get(i).getRef_no()).get(0));  
 			//writing to console
 			System.out.println(searchHitsList.get(i).getRef_no()+" : "+searchHitsList.get(i).getHits());
 			
 		}
 		
 		if(queryResultJobs.isEmpty()||queryResultJobs==null){
 			
 			System.out.println("{\"resultIsEmpty\":true}");
 			responseMessage= "{\"resultIsEmpty\":true}"; 			
 		}
 		
 		else{
 		for(int i=0;i<=queryResultJobs.size()-1;i++)
		{		 
		System.out.println("search results:"+queryResultJobs.get(i).getRef_no()+"/////location: "+queryResultJobs.get(i).getLocation1()+","+queryResultJobs.get(i).getLocation2()+","+queryResultJobs.get(i).getLocation3()+","+queryResultJobs.get(i).getLocation4()
				+"/////jobtitle: "+queryResultJobs.get(i).getJob_title()+"/////exp: "+queryResultJobs.get(i).getExp()+"//////topics: "+queryResultJobs.get(i).getTopic1()+","+queryResultJobs.get(i).getTopic2()+","+queryResultJobs.get(i).getTopic3()+","+queryResultJobs.get(i).getTopic4());
		}
 		ObjectMapper mapper=new ObjectMapper();
 		StringWriter sw =new StringWriter();
 		
 		try {
			mapper.writeValue(sw, queryResultJobs);
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
		}
 		
 		if(!errorMessage.isEmpty()){
 			responseMessage=errorMessage;
 		}		
 		
 		return responseMessage;
     }
	 
 }