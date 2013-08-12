package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utility.DbUtilHelper;

import dao.JobsDao;
import model.Jobs;




public class test extends HttpServlet {
	
	
	
	public test(){
		super();
	}
	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		List<Jobs> myjobs=new ArrayList<Jobs>();
		JobsDao myJobsDao=new JobsDao();
		
		//myjobs=myJobsDao.queryJobsByLocation("munich");
		myjobs=myJobsDao.queryJobsByDefinedCriteria(null, "munich", null, null);
		for(int i=0;i<=myjobs.size()-1;i++)
		{		 
		System.out.println("search results:"+myjobs.get(i).getRef_no());
		}
		
	}

}
