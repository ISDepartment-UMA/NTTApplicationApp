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
	public static String nttDB = "java:comp/env/jdbc/nttDB";
	
	
	public test(){
		super();
	}
	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		List<Jobs> myjobs=new ArrayList<Jobs>();
		JobsDao myJobsDao=new JobsDao();
		DbUtilHelper.initDatasource(nttDB);
		myjobs=myJobsDao.queryJobsByLocation("MŸnchen");
	
		Jobs testJob=new Jobs();
		testJob=myjobs.get(0);
		System.out.println("testJob description:"+testJob.getJob_description());
		
		
	}

}
