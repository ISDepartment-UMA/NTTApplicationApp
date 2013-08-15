package http;

import java.io.File;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import utility.DbUtilHelper;


public class ApplicationServletContextListener implements
		ServletContextListener {	
	public static String bydDB = "java:comp/env/jdbc/nttDB";
	public static String appName = "NTT_Job_Application_Server";
	
	public void contextInitialized(ServletContextEvent event) {
		

		DbUtilHelper.initDatasource(bydDB);
		log("App initialized... Name: " + appName);
	}

	public void contextDestroyed(ServletContextEvent event) {
		log("App stopped: " + appName);
	}

	private void log(String string) {
		System.out.println(string);
	}



}