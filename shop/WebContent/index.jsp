<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
</head>
<body>
	<!-- start : submenu include -->
	<div>
		<!-- 상대주소 <jsp:include page="./partial/submenu.jsp"> -->
		<!-- 절대주소 <jsp:include page="/shop/partial/submenu.jsp"> /으로 시작-->
		<jsp:include page="/partial/submenu.jsp"></jsp:include> 
	</div>
	<!-- end : submenu include -->
	<h1>메인페이지</h1>
</body>
</html>