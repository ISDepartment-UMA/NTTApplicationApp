package controller;
import javapns.Push;
import model.Jobs;

import org.apache.log4j.*;

import dao.ApplicationsDao;
import dao.JobsDao;
import javapns.communication.exceptions.CommunicationException;
import javapns.communication.exceptions.KeystoreException;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NotificationController extends HttpServlet {	
	 
		public NotificationController() {
			super();
		}
		
	protected void doPost(HttpServletRequest request,
				HttpServletResponse response) throws ServletException, IOException {
		
		String device_token=null;
		String[] devices=null;
		
		Jobs job=new Jobs();
		
		if (request.getParameter("ref_no") != null) { 
			job.setRef_no(request.getParameter("ref_no"));	 
		}
		if (request.getParameter("position_name") != null) { 
			job.setPosition_name(request.getParameter("position_name"));	 
		}
		if (request.getParameter("exp") != null) { 
			job.setExp(request.getParameter("exp"));	 
		}
		if (request.getParameter("location1") != null) { 
			job.setLocation1(request.getParameter("location1"));	 
		}
		if (request.getParameter("location2") != null) { 
			job.setLocation2(request.getParameter("location2"));	 
		}
		if (request.getParameter("location3") != null) { 
			job.setLocation3(request.getParameter("location3"));	 
		}
		if (request.getParameter("location4") != null) { 
			job.setLocation4(request.getParameter("location4"));	 
		}
		if (request.getParameter("job_title") != null) { 
			job.setJob_title(request.getParameter("job_title"));	 
		}
		if (request.getParameter("topic1") != null) { 
			job.setTopic1(request.getParameter("topic1"));	 
		}
		if (request.getParameter("topic2") != null) { 
			job.setTopic2(request.getParameter("topic2"));	 
		}
		if (request.getParameter("topic3") != null) { 
			job.setTopic3(request.getParameter("topic3"));	 
		}
		if (request.getParameter("topic4") != null) { 
			job.setTopic4(request.getParameter("topic4"));	 
		}
		if (request.getParameter("contact_person") != null) { 
			job.setContact_person(request.getParameter("contact_person"));	 
		}
		if (request.getParameter("phone_no") != null) { 
			job.setPhone_no(request.getParameter("phone_no"));	 
		}
		if (request.getParameter("email") != null) { 
			job.setEmail(request.getParameter("email"));	 
		}
		if (request.getParameter("job_description") != null) { 
			job.setJob_description(request.getParameter("job_description"));	 
		}
		if (request.getParameter("main_tasks") != null) { 
			job.setMain_tasks(request.getParameter("main_tasks"));	 
		}
		if (request.getParameter("job_requirements") != null) { 
			job.setJob_requirements(request.getParameter("job_requirements"));	 
		}
		if (request.getParameter("perspective") != null) { 
			job.setPerspective(request.getParameter("perspective"));	 
		}else{
			job.setPerspective("null");
		}
		if (request.getParameter("our_offer") != null) { 
			job.setOur_offer(request.getParameter("our_offer"));	 
		}else{
			job.setOur_offer("null");
		}
		if (request.getParameter("url") != null) { 
			job.setUrl(request.getParameter("url"));	 
		}
		
		if (request.getParameter("device_token") != null) { 
			 device_token=request.getParameter("device_token");	 
		}
		
		job.setPosition_status("active");
		
		JobsDao jobsDao=new JobsDao();
		jobsDao.insertJob(job);
		ApplicationsDao appDao=new ApplicationsDao();
		
		if(device_token!=null){
		Boolean isNewDevice=true;
		devices=appDao.queryNotificationDevices();
		for(int i=0;i<=devices.length-1;i++){
			if(devices[i].equalsIgnoreCase(device_token))
				isNewDevice=false;			
		}
		if(isNewDevice=true)
		appDao.insertNotificationDevice(device_token);
		}
		
		String notification_content="New Job offers! "+job.getRef_no()+" "+job.getPosition_name();
		
		try {
	        BasicConfigurator.configure();
		} catch (Exception e) {
		}
		
		File keystore= new File("/usr/share/apache-tomcat-7.0.42/webapps/NTT_Job_Application_Server/JobPushService.p12");
		String password="jobpush";
		Boolean production=false;
		devices=appDao.queryNotificationDevices();		  
		
		try {
			Push.alert(notification_content, keystore, password, production, devices);
		} catch (CommunicationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (KeystoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.sendRedirect("addNewJob.jsp");
		
		
	}
	
	

}
