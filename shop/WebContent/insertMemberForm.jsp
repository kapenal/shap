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
		
		// 맴버 아이디 체크 방어코드
		String memberIdCheck = "";
		if(request.getParameter("memberIdCheck") != null) {
			memberIdCheck = request.getParameter("memberIdCheck");
		} else {
			System.out.println("중복된 ID입니다");
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertMemberForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<a href="<%=request.getContextPath()%>/loginForm.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그인</a> <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="btn btn-light" style="width:70pt;height:32pt;">회원가입</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>회원가입</h1>
		</div>
		<!-- memberId가 사용가능한지 확인 폼 -->
		<form method="post" action="<%=request.getContextPath()%>/selectMemberIdCheckAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>아이디</td>
					<td><input type="text" name="memberIdCheck" value="<%=memberIdCheck%>" placeholder="ID를 입력하세요">
						<button type="submit">아이디 중복 검사</button>
					</td>
				</tr>
			</table>
		</form>
		<!-- 회원가입 폼 -->
		<form id="joinForm" method="post" action="<%=request.getContextPath()%>/insertMemberAction.jsp">
			 <table class="table table-bordered">
				<tr>
					<td>아이디</td>
					<td><input type="text" id="memberId" name="memberId" readonly="readonly" value="<%=memberIdCheck%>" placeholder="ID를 입력하세요"></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td><input type="password" id="memberPw" name="memberPw" placeholder="PW를 입력하세요"></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" id="memberName" name="memberName" placeholder="이름을 입력하세요"></td>
				</tr>
				<tr>
					<td>나이</td>
					<td><input type="text" id="memberAge" name="memberAge" placeholder="나이를 입력하세요"></td>
				</tr>
				<tr>
					<td>성별</td>
					<td>
						<input type="radio" class="memberGender" name="memberGender" value="남">남
						<input type="radio" class="memberGender" name="memberGender" value="여">여
					</td>
				<tr>
			</table>
			<button type="button" id="btn" class="btn btn-light">회원가입</button>
			<a href ="<%=request.getContextPath()%>/index.jsp" class="btn btn-light">취소</a>
		</form>
	</div>
	<!-- form의 value값 유효성 검사 -->
	<script>
		// jQuery();
		$('#btn').click(function(){
			// 버튼을 클릭했을 때
			if($('#memberId').val() == '') { // id가 공백이면
				alert('ID를 입력하세요');
				return;
			}
			if($('#memberPw').val() == '') { // Pw가 공백이면
				alert('PW를 입력하세요');
				return;
			}
			if($('#memberName').val() == '') { // Name가 공백이면
				alert('이름을 입력하세요');
				return;
			}
			if($('#memberAge').val() == '') { // Age가 공백이면
				alert('나이를 입력하세요');
				return;
			}
			// .클래스속성 , 클래스명으로 가져오면 무조건 배열
			let memberGender = $('.memberGender:checked');
			if(memberGender.length == 0) { // Age가 공백이면
				alert('성별을 선택하세요');
				return;
			}
			$('#joinForm').submit(); // <button type="button"> --> <button type="submit">
		});
	</script>
</body>
</html>