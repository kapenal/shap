<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo") == "") {
		System.out.println("잘못된 QnA 번호");
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	
	// 작성자만 허용 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberNo() != qna.getMemberNo()){
		System.out.println("작성자가 아닙니다");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateQnaForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>QnA 수정</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<form id="updateQnaForm" method="post" action="<%=request.getContextPath()%>/updateQnaAction.jsp">
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
					<td>QnA 제목 : <input type="text" id="qnaTitle" name="qnaTitle" value="<%=qna.getQnaTitle()%>"></td>
				</tr>
				<tr>
					<td><textarea class="form-control" rows="5" id="qnaContent" name="qnaContent" ><%=qna.getQnaContent()%></textarea></td>
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
				<button  id="updateqnaBtn" type="button" class="btn btn-light" >작성 완료</button>
			</div>
			<input type="hidden" name="qnaNo" value="<%=qnaNo%>" readonly="readonly">
		</form>
	</div>
	<script>
	$('#updateqnaBtn').click(function(){
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
		$('#updateQnaForm').submit(); // <button type="button"> --> <button type="submit">
	});
	</script>
</body>
</html>