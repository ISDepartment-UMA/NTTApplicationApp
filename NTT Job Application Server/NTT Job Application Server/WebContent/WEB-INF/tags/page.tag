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
<title><fmt:message key="app.name" /></title>
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
			<a class=pull-right href="http://www.bradler-gmbh.de/de/bydesign-essentials">
				<img src="assets/img/bradler-solutions.gif" alt="Bradler GmbH">
			</a>
		</div>

      <div class="left-nav well">
      <c:choose>
       	  <c:when test="${pageId=='BCOrder'||pageId=='BCOrder2'}">
      		<ul class="nav nav-list">
         	 <li <c:if test="${pageId=='BCOrder'}"> class="active" </c:if> class="nav-header"><a href="order/BusinessCardOrder.jsp"><fmt:message key="businessCard" /></a></li>
           	 <li <c:if test="${pageId=='BCOrder2'}"> class="active" </c:if> ><a href="order/BusinessCardOrder2.jsp"><fmt:message key="BCOrder2.confirmation" /></a></li>
            </ul>
    	  </c:when>
    	  <c:otherwise> 
        <ul class="nav nav-list">
          <li <c:if test="${pageId=='admin.index'}"> class="active" </c:if> class="nav-header"><a href="admin"><fmt:message key="businessCard" /></a></li>
          <li <c:if test="${pageId=='companyProfile'}"> class="active" </c:if>><a href="admin/companyProfile.jsp"><fmt:message key="companyProfile" /></a></li> <% // if pageId=companyProfile class=active  %>
          <li <c:if test="${pageId=='logoUpload'}"> class="active" </c:if>><a href="admin/logoUpload.jsp"><fmt:message key="upload" /></a></li>
          <li <c:if test="${pageId=='chooseDesign'}"> class="active" </c:if>><a href="admin/chooseDesign.jsp"><fmt:message key="chooseDesign" /></a></li>
        </ul>
        </c:otherwise>
         
        </c:choose>
      </div><!--/.well -->
	<div class=right-content>
		<div class="alert alert-info">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<i class="icon-info-sign"></i> <fmt:message key="${pageId}.info" />
		</div>
		<c:if test="${not empty alert}">
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			<i class="icon-remove-sign"></i> <fmt:message key="${pageId}.error.${alert}" />
		</div>
		</c:if>
		<jsp:doBody />
	</div>
	</div>

</body>
</html>