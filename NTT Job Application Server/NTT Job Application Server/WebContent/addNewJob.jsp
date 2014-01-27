<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags"%>
<t:page pageId="index">
	<jsp:body> 
	
	<form method="POST" id=signIn action="Noti">
			<div class=content>
	<table> 
				<tr>
					<td class="col_1">Reference No.<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="ref_no" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Position Name<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="position_name" type="text"   required /> <td>
				</tr>
				
				
				
				<tr>				
					<td class="col_1">Experience<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="exp"   >
										
						<option value="students">Students</option>
						<option value="young professional/graduate">Young Professional/Graduate</option>
						<option value="senior professional">Senior Professional</option>
						<option value="professional">Professional</option>						
						 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Location1<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="location1">										
						<option value="cologne">Cologne</option>
						<option value="deutschlandweit">Deutschlandweit</option>
						<option value="ettlingen">Ettlingen</option>
						<option value="frankfurt">Frankfurt</option>
						<option value="hamburg">Hamburg</option>
						<option value="hannover">Hannover</option>
						<option value="munich">Munich</option>
						<option value="stuttgart">Stuttgart</option>					 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Location2<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="location2">										
						<option value="cologne">Cologne</option>
						<option value="deutschlandweit">Deutschlandweit</option>
						<option value="ettlingen">Ettlingen</option>
						<option value="frankfurt">Frankfurt</option>
						<option value="hamburg">Hamburg</option>
						<option value="hannover">Hannover</option>
						<option value="munich">Munich</option>
						<option value="stuttgart">Stuttgart</option>
						<option value="null">null</option>					 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Location3<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="location3">										
						<option value="cologne">Cologne</option>
						<option value="deutschlandweit">Deutschlandweit</option>
						<option value="ettlingen">Ettlingen</option>
						<option value="frankfurt">Frankfurt</option>
						<option value="hamburg">Hamburg</option>
						<option value="hannover">Hannover</option>
						<option value="munich">Munich</option>
						<option value="stuttgart">Stuttgart</option>
						<option value="null">null</option>					 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Location4<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="location4">										
						<option value="cologne">Cologne</option>
						<option value="deutschlandweit">Deutschlandweit</option>
						<option value="ettlingen">Ettlingen</option>
						<option value="frankfurt">Frankfurt</option>
						<option value="hamburg">Hamburg</option>
						<option value="hannover">Hannover</option>
						<option value="munich">Munich</option>
						<option value="stuttgart">Stuttgart</option>
						<option value="null">null</option>					 
					</select>
					</td>
				</tr>
				
				 
				
				<tr>				
					<td class="col_1">Job Title<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="job_title"   >
										
						<option value="consultant">Consultant</option>
						<option value="project manager">Project Manager</option>
						<option value="students">Students</option>
						<option value="technical consultant">Technical Consultant</option>						
						 
					</select>
					</td>
				</tr>
				
				
				<tr>				
					<td class="col_1">Topic1<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="topic1"   >
										
						<option value="application management">Application Management</option>
						<option value="business intelligence">Business Intelligence</option>
						<option value="business process management">Business Process Management</option>
						<option value="corporate functions">Corporate Functions</option>
						<option value="customer management">Customer Management</option>
						<option value="finance transformation">Finance Transformation</option>
						<option value="financial services">Financial Services</option>
						<option value="it and methods">IT and Methods</option>
						<option value="it management">IT Management</option>
						<option value="management consulting">Management Consulting</option>
						<option value="manufacturing">Manufacturing</option>
						<option value="public">Public</option>
						<option value="sales">Sales</option>
						<option value="sap consulting">SAP Consulting</option>
						<option value="service and logistics">Service and Logistics</option>
						<option value="telecommunication">Telecommunication</option>
						<option value="utilities">Utilities</option>					 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Topic2<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="topic2"   >
										
						<option value="application management">Application Management</option>
						<option value="business intelligence">Business Intelligence</option>
						<option value="business process management">Business Process Management</option>
						<option value="corporate functions">Corporate Functions</option>
						<option value="customer management">Customer Management</option>
						<option value="finance transformation">Finance Transformation</option>
						<option value="financial services">Financial Services</option>
						<option value="it and methods">IT and Methods</option>
						<option value="it management">IT Management</option>
						<option value="management consulting">Management Consulting</option>
						<option value="manufacturing">Manufacturing</option>
						<option value="public">Public</option>
						<option value="sales">Sales</option>
						<option value="sap consulting">SAP Consulting</option>
						<option value="service and logistics">Service and Logistics</option>
						<option value="telecommunication">Telecommunication</option>
						<option value="utilities">Utilities</option>
					 					
						 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Topic3<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="topic3"   >
										
						<option value="application management">Application Management</option>
						<option value="business intelligence">Business Intelligence</option>
						<option value="business process management">Business Process Management</option>
						<option value="corporate functions">Corporate Functions</option>
						<option value="customer management">Customer Management</option>
						<option value="finance transformation">Finance Transformation</option>
						<option value="financial services">Financial Services</option>
						<option value="it and methods">IT and Methods</option>
						<option value="it management">IT Management</option>
						<option value="management consulting">Management Consulting</option>
						<option value="manufacturing">Manufacturing</option>
						<option value="public">Public</option>
						<option value="sales">Sales</option>
						<option value="sap consulting">SAP Consulting</option>
						<option value="service and logistics">Service and Logistics</option>
						<option value="telecommunication">Telecommunication</option>
						<option value="utilities">Utilities</option>
					 					
						 
					</select>
					</td>
				</tr>
				
				<tr>				
					<td class="col_1">Topic4<font color="blue" style="position:relative; top:2px;">*</font></td>
					<td width="10"></td>
					<td> <select name="topic4"   >
										
						<option value="application management">Application Management</option>
						<option value="business intelligence">Business Intelligence</option>
						<option value="business process management">Business Process Management</option>
						<option value="corporate functions">Corporate Functions</option>
						<option value="customer management">Customer Management</option>
						<option value="finance transformation">Finance Transformation</option>
						<option value="financial services">Financial Services</option>
						<option value="it and methods">IT and Methods</option>
						<option value="it management">IT Management</option>
						<option value="management consulting">Management Consulting</option>
						<option value="manufacturing">Manufacturing</option>
						<option value="public">Public</option>
						<option value="sales">Sales</option>
						<option value="sap consulting">SAP Consulting</option>
						<option value="service and logistics">Service and Logistics</option>
						<option value="telecommunication">Telecommunication</option>
						<option value="utilities">Utilities</option>
					 					
						 
					</select>
					</td>
				</tr>
				
				<tr>
					<td class="col_1">Contact Person<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="contact_person" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Phone No.<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="phone_no" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Email<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="email" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Job Description<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="job_description" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Main Tasks<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="main_tasks" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Job Requirements<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="job_requirements" type="text"   required /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Perspective</td>
						<td width="10"></td>
					<td> <input name="perspective" type="text" /> <td>
				</tr>
				
				<tr>
					<td class="col_1">Our Offer</td>
						<td width="10"></td>
					<td> <input name="our_offer" type="text" /> <td>
				</tr>
				
				<tr>
					<td class="col_1">URL<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="url" type="text"   required /> <td>
				<tr height="40">
				<td></td><td></td><td></td></tr>
				 
				
				<tr>
				<td>Adding new device:</td>
				</tr>
				<tr>
					<td class="col_1">Device Token<font color="blue" style="position:relative; top:2px;">*</font></td>
						<td width="10"></td>
					<td> <input name="device_token" type="text"   /> <td>
				</tr>
				
							
				
				</table>								
	
	
		
				 
			</div>
			<div class="form-actions">
				<button class="btn btn-small" type="submit">Submit</button>
			</div>
		</form>
		 
	</jsp:body>
</t:page>