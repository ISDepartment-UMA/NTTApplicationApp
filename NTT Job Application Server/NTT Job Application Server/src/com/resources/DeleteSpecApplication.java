package com.resources;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import model.Applications;
import model.Jobs;
import model.SpeculativeApplication;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import dao.ApplicationsDao;

@Path("/delete_spec_application")
public class DeleteSpecApplication {

	@POST
	@Consumes({ MediaType.TEXT_PLAIN, MediaType.APPLICATION_JSON,
			MediaType.APPLICATION_XML })
	public String deleteapplication(String message) {
		String uuid = null;
		String device_id = null;

		Boolean isSuccessfulDeleted = null;

		String errorMessage = "";
		String responseMessage = null;

		System.out.println("posted string:" + message);

		try {
			JSONObject jsonObject = new JSONObject(message);

			if (jsonObject.has("uuid")) {
				uuid = jsonObject.getString("uuid");
			} else {
				errorMessage += " the parameter : uuid is missing! ";
			}

			if (jsonObject.has("device_id")) {
				device_id = jsonObject.getString("device_id");
			} else {
				errorMessage += " the parameter : device_id is missing! ";
			}

		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		ApplicationsDao appDao = new ApplicationsDao();

		if (uuid != null && device_id != null) {

			if (appDao.querySpecApplications(device_id, uuid) != null) {

				isSuccessfulDeleted = appDao.deleteSpecApplications(uuid);

				if (isSuccessfulDeleted == true)
					responseMessage = "{\"delete_SpecApplication_successful\":\"true\",\"device_id\":\""
							+ device_id + "\",\"uuid\":\"" + uuid + "\"}";

			} else {
				errorMessage += " the target speculative application doesn't exist! ";
			}
		}

		else {
			if (uuid == null) {
				errorMessage += " the parameter uuid can't be null! ";
			}

			if (device_id == null) {
				errorMessage += " the parameter device_id can't be null! ";
			}

		}
		if (!errorMessage.isEmpty()) {
			responseMessage = errorMessage;
		}

		return responseMessage;
	}

}