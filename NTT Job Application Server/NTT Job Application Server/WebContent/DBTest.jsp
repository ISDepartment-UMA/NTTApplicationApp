<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<sql:query var="rs" dataSource="jdbc/nttDB">
SELECT DISTINCT * FROM jobs WHERE 1=1 AND location1='munich' OR location2='munich' OR location3='munich' OR location4='munich'
</sql:query>

<html>
  <head>
    <title>DB Test</title>
  </head>
  <body>

  <h2>Results</h2>

<c:forEach var="row" items="${rs.rows}">
    Ref_No ${row.ref_no}<br/>    
    positionName ${row.posotion_name}<br/>
    Experience ${row.exp}<br/> 
    location1 ${row.location1}<br/>
    location2 ${row.location2}<br/>
    location3 ${row.location3}<br/>
    location4 ${row.location4}<br/>
       
</c:forEach>

<form accept-charset="UTF-8" method="post" action="Test"
							name="VCARD1">
			<input type="submit" id="button1" name="design1"
								value="submit" />
			

			</form>		
  </body>
</html>