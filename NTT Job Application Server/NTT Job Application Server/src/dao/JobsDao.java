package dao;

import model.Jobs;
import utility.DbUtilHelper;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;


import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.ArrayListHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;



import java.util.UUID;

public class JobsDao {
	// the properties of dao
	private QueryRunner run;
	private ResultSetHandler<List<Jobs>> h;
	private String dbTable = "jobs";
	private String query;
	

	public JobsDao() {
		run = DbUtilHelper.getQueryRunner();
		h = new BeanListHandler<Jobs>(Jobs.class);
		
	}

	// now we write database actions
	public Boolean checkJobTitleInput(String jobtitle) {
		ResultSet rs=null;
		Boolean test=null;
		query = "SELECT * FROM jobtitle WHERE jobtitle='" + jobtitle
				+ "'";
		try{
			Statement stmt=DbUtilHelper.getConnection().createStatement();
			rs=stmt.executeQuery(query);
			DbUtilHelper.log("checkJobTitleInput success: " + query);
			 
			if(rs.next()){
				test=true;
			}				
				else{
					test=false;
			}			
			DbUtilHelper.log("checkJobTitleInput: " + test);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("checkJobTitleInput failed");

		}

		 return test;
		

	}
	
	public Boolean checkLocationInput(String location) {
		ResultSet rs=null;
		Boolean test=null;
		query = "SELECT * FROM locations WHERE location='" + location
				+ "'";
		try{
			Statement stmt=DbUtilHelper.getConnection().createStatement();
			rs=stmt.executeQuery(query);
			DbUtilHelper.log("checkLocationInput success: " + query);
			 
			if(rs.next()){				
				test=true;				
			}				
			else{
				test=false;
			}			
			DbUtilHelper.log("checkLocationInput: " + test);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("checkLocationInput failed");

		}

		 return test;
		

	}
	
	public Boolean checkTopicsInput(String topics) {
		ResultSet rs=null;
		Boolean test=null;
		query = "SELECT * FROM topics WHERE topic='" + topics
				+ "'";
		try{
			Statement stmt=DbUtilHelper.getConnection().createStatement();
			rs=stmt.executeQuery(query);
			DbUtilHelper.log("checkTopicsInput success: " + query);
			 
			if(rs.next()){				
				test=true;
			}				
			else{
				test=false;
			}
			DbUtilHelper.log("checkTopicsInput: "+test);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("checkTopicsInput failed");

		}

		 return test;
		

	}
	
	public Boolean checkExpInput(String exp) {
		ResultSet rs=null;
		Boolean test=null;
		query = "SELECT * FROM experience WHERE experience='" + exp
				+ "'";
		try{
			Statement stmt=DbUtilHelper.getConnection().createStatement();
			rs=stmt.executeQuery(query);
			DbUtilHelper.log("checkExpInput success: " + query);
			 
			if(rs.next()){				
				test=true;
			}				
			else{
				test=false;
			}
			DbUtilHelper.log("checkExpInput: "+test);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("checkExpInput failed");

		}

		 return test;
		

	}
	
	
	public List<Jobs> queryJobsByTopic(String topic) {
		List<Jobs> jobs = null;
		query = "SELECT DISTINCT * FROM " + dbTable + " WHERE topic1='" + topic
				+ "' OR topic2='" + topic + "' OR topic3='" + topic + "' OR topic4='"+ topic + "'";
	
		try {
			jobs = run.query(query, h);
			DbUtilHelper.log("queryJobsByTopic success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryJobsByTopic failed");

		}

		if (jobs.isEmpty()) {
			DbUtilHelper.log("queryJobsByTopic result is empty!");

		}

		return jobs.isEmpty() ? null : jobs;

	}
	
	public List<Jobs> queryJobsByExperience(String exp) {
		List<Jobs> jobs = null;
		query = "SELECT * FROM " + dbTable + " WHERE exp='" + exp
				+ "'";
		try {
			jobs = run.query(query, h);
			DbUtilHelper.log("queryJobsByExperience success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryJobsByExperience failed");

		}

		if (jobs.isEmpty()) {
			DbUtilHelper.log("queryJobsByExperience result is empty!");

		}

		return jobs.isEmpty() ? null : jobs;

	}

	public List<Jobs> queryJobsByDefinedCriteria(String jobtitle, String location, String topic, String exp) {
		List<Jobs> jobs = null;
		query = "SELECT DISTINCT * FROM " + dbTable + " WHERE 1=1 ";
		if(jobtitle!=null&&!jobtitle.equalsIgnoreCase("null")){
		query+="AND job_title='" + jobtitle	+ "'";
		}
		if(location!=null&&!location.equalsIgnoreCase("null")){
		query+="AND ( location1='" + location	+ "' OR location2='" + location + "' OR location3='" + location + "' OR location4='"+ location + "' )";
		}
		if(topic!=null&&!topic.equalsIgnoreCase("null")){
		query+=" AND ( topic1='" + topic	+ "' OR topic2='" + topic + "' OR topic3='" + topic + "' OR topic4='"+ topic + "' )";
		}
		if(exp!=null&&!exp.equalsIgnoreCase("null")){
		query+="AND exp='" + exp + "'";
		}
		
		
		
		
		try {
			jobs = run.query(query, h);
			DbUtilHelper.log("queryJobsByJobTitle success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryJobsByJobTitle failed");

		}

		if (jobs.isEmpty()) {
			DbUtilHelper.log("queryJobsByJobTitle result is empty!");

		}

		return jobs.isEmpty() ? null : jobs;

	}

}

