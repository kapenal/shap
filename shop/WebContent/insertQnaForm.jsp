<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() > 0){
		System.out.println("일반계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>QnA 작성</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<form id="QnaForm" method="post" action="<%=request.getContextPath()%>/insertQnaAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>
						카테고리
						<select id="qnaCategory" name="qnaCategory">
							<option value="전자책관련">전자책관련</option>
							<option value="개인정보관련">개인정보관련</option>
							<option value="기타">기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>QnA 제목 : <input type="text" id="qnaTitle" name="qnaTitle"></td>
				</tr>
				<tr>
					<td><textarea class="form-control" rows="5" id="qnaContent" name="qnaContent"></textarea></td>
				</tr>
				<tr>
					<td>
						비밀글
						<input type="radio" class="qnaSecret" name="qnaSecret" value="Y">YES
						<input type="radio" class="qnaSecret" name="qnaSecret" value="N">NO
					</td>
				<tr>
			</table>
			<div style="text-align:right">
				<button  id="qnaBtn" type="button" class="btn btn-light" >작성 완료</button>
			</div>
			<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>" readonly="readonly">
			<input type="hidden" name="memberName" value="<%=loginMember.getMemberName()%>" readonly="readonly">
		</form>
	</div>
	<script>
	$('#qnaBtn').click(function(){
		// 버튼을 클릭했을 때
		if($('#qnaTitle').val() == '') { // 제목이 공백이면
			alert('제목을 입력하세요');
			return;
		}
		if($('#qnaCategory').val() == '') { // 카테고리가 공백이면
			alert('카테고리를 선택하세요');
			return;
		}
		if($('#qnaContent').val() == '') { // 내용이 공백이면
			alert('내용을 입력하세요');
			return;
		}
		// .클래스속성 , 클래스명으로 가져오면 무조건 배열
		let qnaSecret = $('.qnaSecret:checked');
		if(qnaSecret.length == 0) { // 비밀글 여부가 공백이면
			alert('비밀글 여부를 선택하세요');
			return;
		}
		$('#QnaForm').submit(); // <button type="button"> --> <button type="submit">
	});
	</script>
</body>
</html>