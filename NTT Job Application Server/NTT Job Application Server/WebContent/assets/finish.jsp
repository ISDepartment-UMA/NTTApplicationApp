<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Demo Finish</title>
<meta name="robots" content="noindex, nofollow" />
</head>
<body>
<h1>Demo Finish</h1>
	<%@ page import="java.util.Enumeration"%>
	<%
		Enumeration enParams = request.getParameterNames();
		while (enParams.hasMoreElements()) {
			String paramName = (String) enParams.nextElement();
			out.println("<p>" + paramName + ": " + request.getParameter(paramName)+"</p>");
		}
	%>
</body>
</html>