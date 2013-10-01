package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import model.Experience;
import model.Jobtitle;
import model.Locations;
import model.Topics;
import model.Applications;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import utility.DbUtilHelper;

public class ApplicationsDao {
	
	// the properties of dao
		private QueryRunner run;
		private ResultSetHandler<List<Applications>> applicationsHandler;
		 
		
		private String query;
		

		public ApplicationsDao() {
			run = DbUtilHelper.getQueryRunner();
			applicationsHandler = new BeanListHandler<Applications>(Applications.class);			 
		}

		 
		public Boolean insertApplications(Applications application){
			 
			Boolean test=null;
			query = "SELECT * FROM jobtitle WHERE jobtitle=''";
			String query = "insert into applications (device_id, job_ref_no, apply_time, application_status, email, first_name, last_name, address, phone_no ) VALUES (";
			query += "\"" + application.getDevice_id() + "\"" + ",";
			query += "\"" + application.getJob_ref_no() + "\"" + ",";
			query += "\"" + application.getApply_time() + "\"" + ",";
			query += "\"" + application.getApplicaton_status() + "\"" + ",";
			query += "\"" + application.getEmail() + "\"" + ",";
			query += "\"" + application.getFirst_name() + "\"" + ",";
			query += "\"" + application.getLast_name() + "\"" + ",";
			query += "\"" + application.getAddress() + "\"" + ",";
			query += "\"" + application.getPhone_no() + "\"" + ",";			 
			query += ")";
			
			 
			
			 
			
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_insert_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("insertApplications success: " + query);
				 
				if(after_insert_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("insertApplications: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("insertApplications failed");

			}

			 return test;
			

		}
		
		
	 
	

}
