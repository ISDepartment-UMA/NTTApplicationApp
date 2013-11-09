package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import model.Experience;
import model.FAQrates;
import model.FilterSet;
import model.Jobs;
import model.Jobtitle;
import model.Locations;
import model.Topics;
import model.Applications;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import utility.DbUtilHelper;

public class FilterSetsDao {
	
	// the properties of dao
		private QueryRunner run;
		private ResultSetHandler<List<FilterSet>> filterSetsHandler;
		 
		 
		
		private String query;
		

		public FilterSetsDao() {
			run = DbUtilHelper.getQueryRunner();
			filterSetsHandler = new BeanListHandler<FilterSet>(FilterSet.class);	
			 
		}
		
		public Boolean insertFilterSet(FilterSet filterSet){
			 
			Boolean test=null;			 
			String query = "insert into filtersets (uuid, device_id, job_title, location, topic, exp) VALUES (";
			query += "\"" + filterSet.getUuid() + "\"" + ",";
			query += "\"" + filterSet.getDevice_id() + "\"" + ",";
			query += "\"" + filterSet.getJob_title() + "\"" + ",";
			query += "\"" + filterSet.getLocation() + "\"" + ",";
			query += "\"" + filterSet.getTopic() + "\""+ ",";
			query += "\"" + filterSet.getExp() + "\"";
			query += ")";	
			 		
			try{
				System.out.println("query: "+query);
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_insert_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("insertFilterSet success: " + query);
				 
				if(after_insert_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("insertFilterSet: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("insertFilterSet failed");
			}
			 return test;
		}
		
		public List<FilterSet> queryFilterSetsbyDeviceID(String device_id){
			
			
			List<FilterSet> filterSets = null;
			query = "SELECT * FROM filtersets WHERE device_id = '" + device_id
					+ "'";
			
			try {
				filterSets = run.query(query, filterSetsHandler);
				DbUtilHelper.log("queryFilterSetsbyDeviceID success: " + query);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("queryFilterSetsbyDeviceID failed");

			}

			if (filterSets.isEmpty()) {
				DbUtilHelper.log("queryFilterSetsbyDeviceID result is empty!");

			}

			return filterSets.isEmpty() ? null : filterSets;		
		}


		public Boolean deleteFilterSet(String uuid){
			 
			Boolean test=null;			 
			String query = "delete from filtersets where uuid = '" + uuid + "'";
			 		
			try{
				Statement stmt=DbUtilHelper.getConnection().createStatement();		 
				int after_delete_num=stmt.executeUpdate(query);				 
				DbUtilHelper.log("deleteFilterSet success: " + query);
				 
				if(after_delete_num>=0){
					test=true;
				}				
					else{
						test=false;
				}			
				DbUtilHelper.log("deleteFilterSet: " + test);
			} catch (SQLException e) {
				e.printStackTrace();
				DbUtilHelper.log("deleteFilterSet failed");
			}
			 return test;
		}
		 

 
 
		
}
