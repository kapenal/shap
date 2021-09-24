<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>이미지 수정</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<!-- mult/form-data : 액션으로 기계어코드를 넘길때 사용-->
		<!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용-->	
		<form action="<%=request.getContextPath()%>/admin/updateEbookImgAction.jsp" method="post" enctype="multipart/form-data">
			<input type="text" name="ebookNo" value="<%=ebookNo%>"readonly="readonly"> <!-- type="hidden" -->
			<input type="file" name="ebookImg">
			<button type="submit">이미지파일 수정</button>
		</form>
	</div>
</body>
</html>