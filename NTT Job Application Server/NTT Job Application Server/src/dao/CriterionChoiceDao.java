package dao;

import model.Experience;
import model.Jobs;
import model.Jobtitle;
import model.Locations;
import model.Topics;
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

public class CriterionChoiceDao {
	// the properties of dao
	private QueryRunner run;
	private ResultSetHandler<List<Experience>> expHandler;
	private ResultSetHandler<List<Jobtitle>> jobtitleHandler;
	private ResultSetHandler<List<Locations>> locationHandler;
	private ResultSetHandler<List<Topics>> topicsHandler;
	
	private String query;
	

	public CriterionChoiceDao() {
		run = DbUtilHelper.getQueryRunner();
		expHandler = new BeanListHandler<Experience>(Experience.class);
		jobtitleHandler= new BeanListHandler<Jobtitle>(Jobtitle.class);
		locationHandler= new BeanListHandler<Locations>(Locations.class);
		topicsHandler= new BeanListHandler<Topics>(Topics.class);
	}

	 
	public List<Experience> queryExperienceChoice(){
		List<Experience> experience = null;
		query = "SELECT DISTINCT * FROM experience";
		
		try {
			experience = run.query(query, expHandler);
			DbUtilHelper.log("queryExperienceChoice success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryExperienceChoice failed");
		}
		if (experience.isEmpty()) {
			DbUtilHelper.log("queryExperienceChoice result is empty!");
		}
		return experience.isEmpty() ? null : experience;
	}
	
	
	public List<Jobtitle> queryJobtitleChoice(){
		List<Jobtitle> jobtitle = null;
		query = "SELECT DISTINCT * FROM jobtitle";
		
		try {
			jobtitle = run.query(query, jobtitleHandler);
			DbUtilHelper.log("queryJobtitleChoice success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryJobtitleChoice failed");
		}
		if (jobtitle.isEmpty()) {
			DbUtilHelper.log("queryJobtitleChoice result is empty!");
		}
		return jobtitle.isEmpty() ? null : jobtitle;
	}
	
	
	public List<Locations> queryLocationsChoice(){
		List<Locations> locations = null;
		query = "SELECT DISTINCT * FROM locations";
		
		try {
			locations = run.query(query, locationHandler);
			DbUtilHelper.log("queryLocationsChoice success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryLocationsChoice failed");
		}
		if (locations.isEmpty()) {
			DbUtilHelper.log("queryLocationsChoice result is empty!");
		}
		return locations.isEmpty() ? null : locations;
	}
	
	public List<Topics> queryTopicsChoice(){
		List<Topics> topics = null;
		query = "SELECT DISTINCT * FROM topics";
		
		try {
			topics = run.query(query, topicsHandler);
			DbUtilHelper.log("queryTopicsChoice success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryTopicsChoice failed");
		}
		if (topics.isEmpty()) {
			DbUtilHelper.log("queryTopicsChoice result is empty!");
		}
		return topics.isEmpty() ? null : topics;
	}

}

