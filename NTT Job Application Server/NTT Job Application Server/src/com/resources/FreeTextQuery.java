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
			freetext=jsonObject.getString("freetext");			 
			System.out.println("freetext: "+freetext);
			 
			
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		 
    	 List<Jobs> myjobs=new ArrayList<Jobs>();
 		JobsDao myJobsDao=new JobsDao(); 	
 		List<SearchHits> searchHitsList=new ArrayList<SearchHits>();
 		 
 		 /////DAO method
 		List<String> freetextList=new ArrayList<String>();
 		String freetextelementsArray[]=new String[50];
 		freetextelementsArray=freetext.split(" ");
 	/*	for(int i=0;i<=freetextelementsArray.length-1;i++){          // to make it lower case
 			freetextelementsArray[i]=freetextelementsArray[i].toLowerCase();
 		}
 	*/
 		myjobs=myJobsDao.queryJobsByDefinedCriteria(null, null, null, null); //get all jobs
 		for(int i=0;i<=myjobs.size()-1;i++){          // iterate all the jobs
 			SearchHits searchHits=new SearchHits();            //create hit records for each job
 			searchHits.setRef_no(myjobs.get(i).getRef_no());
 			searchHits.setHits(0);
 			searchHitsList.add(i, searchHits);
 			for(int j=0;j<=freetextelementsArray.length-1;j++){       //iterate all the free text elements
 				if(myjobs.get(i).getRef_no()!=null&&myjobs.get(i).getRef_no().contains(freetextelementsArray[j])){    //ref_no hits
 				int hits=searchHits.getHits();
 				hits++;
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
 
 		for(int i=0;i<=searchHitsList.size()-1;i++){				//writing to console
 			System.out.println(searchHitsList.get(i).getRef_no()+" : "+searchHitsList.get(i).getHits());
 			
 		}
 		if(myjobs.isEmpty()||myjobs==null){
 			
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
 		
 		
 		return responseMessage;
     }
	 
 }