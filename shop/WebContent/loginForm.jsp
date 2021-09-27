<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	if(session.getAttribute("loginMember") != null){
		System.out.println("이미 로그인 되어 있습니다.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>로그인</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
			 <table class="table table-bordered">
				<tr>
					<td>아이디</td>
					<td><input type="text" name="memberId"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" name="memberPw"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-light">로그인</button>
			<a href ="<%=request.getContextPath()%>/index.jsp" class="btn btn-light">취소</a>
		</form>
	</div>
</body>
</html>