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
		<!-- start : mainMenu include -->
		<div>
			<!-- 절대주소 /으로 시작-->
		<!-- <jsp:include page="/partial/mainMenu.jsp"></jsp:include> --> 
		</div>
		<!-- end : mainMenu include -->
		<div class="jumbotron">
	         <h1>메인 페이지</h1>
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
			<div><h2><span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다.</h2></div>
			<br>
		<%
				if(loginMember.getMemberLevel() > 0){
		%>
					<!-- 관리자 페이지로 가는 링크 -->
					<div><a href ="<%=request.getContextPath()%>/admin/adminIndex.jsp" class="btn btn-info">관리자 페이지가기</a></div>
					<br>
		<%
				}
		%>
			<div><a href ="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-info">로그아웃</a></div>
		<%
			}
		%>
		</div>
	</div>
</body>
</html>