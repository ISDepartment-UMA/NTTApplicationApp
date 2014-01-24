<%@ tag language="java" description="Overall Page template" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t"%>
<%@ attribute name="pageId" required="true"%>
<fmt:setBundle basename="ResourceBundle" scope="application" />
<html>
<head>
<base href="${pageContext.request.contextPath}/">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add New Job</title>
<link href="assets/css/bootstrap.css" rel="stylesheet">
<link href="assets/css/style.css" rel="stylesheet" type="text/css" />

<script src="assets/js/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="assets/js/jquery.validate.js" type="text/javascript"></script>
<script src="assets/js/additional-methods.js" type="text/javascript"></script>
<script src="assets/js/bootstrap.min.js"></script>
<script type="text/javascript" src="assets/js/jquery.table.addrow.js"></script>
<!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
</head>
<body>
	<div id=wrapper>
		<div class=header>
			<a class=pull-right href="http://www.nttdata.com/global/en/">
				<img src="assets/img/header_logo_01.png" alt="NTT Data">
			</a>
		</div>

      
	<div class=right-content>
		<div class="alert alert-info">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<i class="icon-info-sign"></i> please add new job here
		</div>
		<c:if test="${not empty alert}">
		
		</c:if>
		<jsp:doBody />
	</div>
	</div>

</body>
</html>