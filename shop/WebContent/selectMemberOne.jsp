<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		System.out.println("로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/ioginForm.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	Member member = new Member();
	MemberDao memberDao = new MemberDao();
	member = memberDao.selectMemberOne(loginMember.getMemberNo());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectMemberOne.jsp</title>
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
	         <h1>회원정보</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<table class="table table-bordered">
			<tr>
				<td>아이디</td>
				<td><input type="text" id="memberId" name="memberId" readonly="readonly" value="<%=member.getMemberId()%>"></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" id="memberName" name="memberName" readonly="readonly" value="<%=member.getMemberName()%>"></td>
			</tr>
			<tr>
				<td>나이</td>
				<td><input type="text" id="memberAge" name="memberAge" readonly="readonly" value="<%=member.getMemberAge()%>"></td>
			</tr>
			<tr>
				<td>성별</td>
				<td><input type="text" id="memberGender" name="memberGender" readonly="readonly" value="<%=member.getMemberGender()%>"></td>
			</tr>
			<tr>
				<td>회원가입 날짜</td>
				<td><input type="text" id="createDate" name="createDate" readonly="readonly" value="<%=member.getCreateDate()%>"></td>
			</tr>
		</table>
	</div>
</body>
</html>