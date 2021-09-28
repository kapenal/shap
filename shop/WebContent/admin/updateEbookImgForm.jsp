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
	// 방어 코드
	if(request.getParameter("ebookNo") == null){
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp?");
		return;
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// 디버깅
	System.out.println(ebookNo + " < updateEbookImgForm param : ebookNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
		<form id="updateImgForm" action="<%=request.getContextPath()%>/admin/updateEbookImgAction.jsp" method="post" enctype="multipart/form-data">
			<input type="text" name="ebookNo" value="<%=ebookNo%>"readonly="readonly"> <!-- type="hidden" -->
			<input type="file" id="ebookImg" name="ebookImg">
			<button id="updateImgBtn" type="button" class="btn btn-light">이미지파일 수정</button>
		</form>
	</div>
	<script>
		$('#updateImgBtn').click(function(){
			if($('#ebookImg').val() == '') { // 변경할 이미지가 공백이면
				alert('변경할 이미지를 선택하세요');
				return;
			}
			$('#updateImgForm').submit();
		});
	</script>
</body>
</html>