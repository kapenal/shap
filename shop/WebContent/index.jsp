<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- start : submenu include -->
		<div>
			<!-- 절대주소 /으로 시작-->
		<!-- <jsp:include page="/partial/submenu.jsp"></jsp:include> --> 
		</div>
		<!-- end : submenu include -->
		<div class="jumbotron">
	         <h1>메인페이지</h1>
		</div>
		<div>
		<%
			if(session.getAttribute("loginMember") == null){
		%>
			<!-- 로그인 실패 or 전 -->
			<div><a href="<%=request.getContextPath()%>/loginForm.jsp" class="btn btn-info">로그인</a></div>
			<br>
			<div><a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="btn btn-info">회원가입</a></div>
		<%
			}else {
				
				Member loginMember = (Member)session.getAttribute("loginMember");
		%>
			<!-- 로그인 성공 or 유지 -->
			<div><h2><a class="text-warning"><%=loginMember.getMemberName()%></a>님 반갑습니다.</h2></div>
			<br>
			<div><a href ="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-info">로그아웃</a></div>
		<%
			}
		%>
		</div>
	</div>
</body>
</html>