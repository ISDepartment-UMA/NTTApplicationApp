package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import model.Experience;
import model.Jobs;
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
			String query = "insert into applications (device_id, job_ref_no, apply_time, application_status, email, first_name, last_name, address, phone_no ) VALUES (";
			query += "\"" + application.getDevice_id() + "\"" + ",";
			query += "\"" + application.getJob_ref_no() + "\"" + ",";
			query += "\"" + application.getApply_time() + "\"" + ",";
			query += "\"" + application.getApplication_status() + "\"" + ",";
			query += "\"" + application.getEmail() + "\"" + ",";
			query += "\"" + application.getFirst_name() + "\"" + ",";
			query += "\"" + application.getLast_name() + "\"" + ",";
			query += "\"" + application.getAddress() + "\"" + ",";
			query += "\"" + application.getPhone_no() + "\"";			 
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
		
		public Boolean checkRefNOInput(String job_ref_no){
			Boolean test=null;
			ResultSet rs=null;
			query="select * from jobs where ref_no ='"+ job_ref_no+"'";
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();
				rs=stmt.executeQuery(query);
				DbUtilHelper.log("checkRefNOInput success: " + query);
				 
				if(rs.next()){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("checkRefNOInput: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("checkRefNOInput failed");

			}
			 return test;			
		}


		public boolean checkRepeatApply(String job_ref_no, String device_id) {
			Boolean test=null;
			ResultSet rs=null;
			query="select * from applications where job_ref_no ='"+ job_ref_no+"' and device_id = '"+ device_id + "'";
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();
				rs=stmt.executeQuery(query);
				DbUtilHelper.log("checkRepeatApply success: " + query);
				 
				if(rs.next()){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("checkRepeatApply: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("checkRepeatApply failed");

			}
			 return test;					 
		}


		public Boolean deleteApplications(String device_id, String job_ref_no) {
			Boolean test=null;
			//query = "DELETE FROM applications WHERE device_id='"+ device_id +"' and job_ref_no= '" + job_ref_no + "'";
			 query = "UPDATE applications SET application_status= 'withdrawn' where device_id= '"+device_id+"' and job_ref_no='"+job_ref_no+"'";		
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_delete_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("deleteApplications success: " + query);
				 
				if(after_delete_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("deleteApplications: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("deleteApplications failed");
			}
			 return test;
		}
		
		public List<Applications> queryApplications(String device_id, String job_ref_no){
			
			
			List<Applications> applications = null;
			query = "SELECT * FROM applications WHERE device_id = '" + device_id
					+ "' and job_ref_no ='" + job_ref_no + "'";
			
			try {
				applications = run.query(query, applicationsHandler);
				DbUtilHelper.log("queryApplications success: " + query);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("queryApplications failed");

			}

			if (applications.isEmpty()) {
				DbUtilHelper.log("queryApplications result is empty!");

			}

			return applications.isEmpty() ? null : applications;		
		}
		
public List<Applications> queryApplications(String device_id){
			
			
			List<Applications> applications = null;
			query = "SELECT * FROM applications WHERE device_id = '" + device_id
					+ "'";
			
			try {
				applications = run.query(query, applicationsHandler);
				DbUtilHelper.log("queryApplications success: " + query);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("queryApplications failed");

			}

			if (applications.isEmpty()) {
				DbUtilHelper.log("queryApplications result is empty!");

			}

			return applications.isEmpty() ? null : applications;		
		}
		
		
}
