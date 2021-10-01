<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("memberNo") == null || request.getParameter("memberNo") == "") {
		System.out.println("잘못된 접근입니다");
		response.sendRedirect(request.getContextPath()+"/selectMemberOne.jsp?memberNo="+request.getParameter("memberNo"));
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// 로그인한 회원만 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteMemberForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<%
			if(session.getAttribute("loginMember") == null || loginMember.getMemberLevel() < 1){
		%>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%
			} else if(loginMember.getMemberLevel() > 0){
		%>
				<!-- 관리자 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<%	
			}
		%>
		<div class="jumbotron">
	         <h1>회원 탈퇴</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div style="text-align:center">
			<h2>회원 탈퇴하시겠습니까?</h2>
			<h4>탈퇴 시 복구가 불가능합니다</h4>
		</div>
		<div style="text-align:center">
			<a class="btn btn-danger" href="<%=request.getContextPath()%>/deleteMemberAction.jsp?memberNo=<%=memberNo%>">회원 탈퇴</a>
		</div>
	</div>
</body>
</html>