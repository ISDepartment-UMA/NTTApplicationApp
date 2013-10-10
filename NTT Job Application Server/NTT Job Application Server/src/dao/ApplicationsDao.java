package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import model.Experience;
import model.FAQrates;
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
		private ResultSetHandler<List<FAQrates>> faqratesHandler;
		 
		
		private String query;
		

		public ApplicationsDao() {
			run = DbUtilHelper.getQueryRunner();
			applicationsHandler = new BeanListHandler<Applications>(Applications.class);	
			faqratesHandler = new BeanListHandler<FAQrates>(FAQrates.class);
		}
		
		public Boolean insertFAQRates(FAQrates faqrates){
			 
			Boolean test=null;			 
			String query = "insert into faqrates (faq_no,device_id, score) VALUES (";
			query += "\"" + faqrates.getFaq_no() + "\"" + ",";
			query += "\"" + faqrates.getDevice_id() + "\"" + ",";
			query += "\"" + faqrates.getScore() + "\"";
			query += ")";	
			 		
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_insert_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("insertFAQRates success: " + query);
				 
				if(after_insert_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("insertFAQRates: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("insertFAQRates failed");
			}
			 return test;
		}
		
		public List<FAQrates> queryFAQrates(String faq_no){
			
			
			List<FAQrates> faqrates = null;
			query = "SELECT * FROM faqrates WHERE faq_no = '" + faq_no
					+ "'";
			
			try {
				faqrates = run.query(query, faqratesHandler);
				DbUtilHelper.log("queryFAQrates success: " + query);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("queryFAQrates failed");

			}

			if (faqrates.isEmpty()) {
				DbUtilHelper.log("queryFAQrates result is empty!");

			}

			return faqrates.isEmpty() ? null : faqrates;		
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


		public Boolean withdrawApplications(String device_id, String job_ref_no) {
			Boolean test=null;
			//query = "DELETE FROM applications WHERE device_id='"+ device_id +"' and job_ref_no= '" + job_ref_no + "'";
			 query = "UPDATE applications SET application_status= 'withdrawn' where device_id= '"+device_id+"' and job_ref_no='"+job_ref_no+"'";		
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_delete_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("withdrawApplications success: " + query);
				 
				if(after_delete_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("withdrawApplications: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("withdrawApplications failed");
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


public boolean checkRepeatRating(String device_id, String faq_no) {
	Boolean test=null;
	ResultSet rs=null;
	query="select * from faqrates where faq_no ='"+ faq_no +"' and device_id = '"+ device_id + "'";
	try{
		Statement stmt=DbUtilHelper.getConnection().createStatement();
		rs=stmt.executeQuery(query);
		DbUtilHelper.log("checkRepeatRating success: " + query);
		 
		if(rs.next()){
			test=true;
		}				
			else{
				test=false;
		}			
		DbUtilHelper.log("checkRepeatRating: " + test);
	} catch (SQLException e) {
		e.printStackTrace();
		DbUtilHelper.log("checkRepeatRating failed");

	}
	 return test;					 
}
		
		
}
