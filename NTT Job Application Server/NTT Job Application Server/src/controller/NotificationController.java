package controller;
import javapns.Push;
import org.apache.log4j.*;
import javapns.communication.exceptions.CommunicationException;
import javapns.communication.exceptions.KeystoreException;

import java.io.File;

public class NotificationController {
	public static void main(String[] args){
		
		try {
	        BasicConfigurator.configure();
		} catch (Exception e) {
		}
		
		File keystore= new File("/Users/tonyyang/git/NTTApplicationApp/NTT Job Application Server/NTT Job Application Server/WebContent/JobPushService.p12");
		String password="jobpush";
		Boolean production=false;
		String devices="ac6daefc759c9ed0629b65ffedb246fcddfe83211133d72095db8f0ed0cc430e";
		
		try {
			Push.alert("hello world", keystore, password, production, devices);
		} catch (CommunicationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (KeystoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	

}
