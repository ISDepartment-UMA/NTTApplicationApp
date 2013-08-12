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
	public static String nttDB = "java:comp/env/jdbc/nttDB";

	public JobsDao() {
		run = DbUtilHelper.getQueryRunner();
		h = new BeanListHandler<Jobs>(Jobs.class);
		DbUtilHelper.initDatasource(nttDB);
	}

	// now we write database actions
	public List<Jobs> queryJobsByJobTitle(String jobtitle) {
		List<Jobs> jobs = null;
		query = "SELECT * FROM " + dbTable + " WHERE job_title='" + jobtitle
				+ "'";
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
	
	public List<Jobs> queryJobsByLocation(String location) {
		List<Jobs> jobs = null;
		query = "SELECT DISTINCT * FROM " + dbTable + " WHERE location1='" + location
				+ "' OR location2='" + location + "' OR location3='" + location + "' OR location4='"+ location + "'";
		try {
			jobs = run.query(query, h);
			DbUtilHelper.log("queryJobsByLocation success: " + query);
		} catch (SQLException e) {
			e.printStackTrace();
			DbUtilHelper.log("queryJobsByLocation failed");

		}

		if (jobs.isEmpty()) {
			DbUtilHelper.log("queryJobsByLocation result is empty!");

		}

		return jobs.isEmpty() ? null : jobs;

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
		if(jobtitle!=null){
		query+="AND job_title='" + jobtitle	+ "'";
		}
		if(location!=null){
		query+="AND location1='" + location	+ "' OR location2='" + location + "' OR location3='" + location + "' OR location4='"+ location + "'";
		}
		if(topic!=null){
		query+=" AND topic1='" + topic	+ "' OR topic2='" + topic + "' OR topic3='" + topic + "' OR topic4='"+ topic + "'";
		}
		if(exp!=null){
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

