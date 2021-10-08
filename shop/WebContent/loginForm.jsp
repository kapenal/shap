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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<a href="<%=request.getContextPath()%>/loginForm.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그인</a> <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">회원가입</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>로그인</h1>
		</div>
		<form id="loginForm" method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
			 <table class="table table-bordered">
				<tr>
					<td>아이디</td>
					<td><input type="text" id="memberId" name="memberId" placeholder="ID를 입력하세요"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" id="memberPw" name="memberPw" placeholder="PW를 입력하세요"></td>
				</tr>
			</table>
			<button id="loginBtn" type="button" class="btn btn-light">로그인</button>
			<a href ="<%=request.getContextPath()%>/index.jsp" class="btn btn-light">취소</a>
		</form>
	</div>
	<!-- form의 value값 유효성 검사 -->
	<script>
		// jQuery();
		$('#loginBtn').click(function(){
			// 버튼을 클릭했을 때
			if($('#memberId').val() == '') { // id가 공백이면
				alert('ID를 입력하세요');
				return;
			} else if($('#memberPw').val() == '') { // pw가 공백이면
				alert('PW를 입력하세요');
				return;
			} else {
				
			}
			$('#loginForm').submit(); // <button type="button"> --> <button type="submit">
		});
	</script>
</body>
</html>