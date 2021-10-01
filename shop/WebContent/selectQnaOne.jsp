<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 방어 코드
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo") == "") {
		System.out.println("잘못된 QnA 번호");
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// Qna 상세보기 출력 메소드 호출
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	// QnaComment 출력 메소드 호출
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	QnaComment qnaComment = qnaCommentDao.selectQnaComment(qnaNo);
	// 답글이 있는지 확인하는 메소드 호출
	int commentRow = qnaCommentDao.qnaCommentCheck(qnaNo);
	System.out.println(commentRow + " < commentRow");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectQnaOne.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
	         <h1>QnA</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<a style="width:7%; text-align:center" href="<%=request.getContextPath()%>/selectQnaList.jsp" class="btn btn-light">목록</a>
		<table class="table table-bordered">
			<tr>
				<td style="width:7%; text-align:center">No.<%=qna.getQnaNo()%></td>
				<td style="width:12%; text-align:center"><%=qna.getQnaCategory()%></td>
				<td><%=qna.getQnaTitle()%></td>
				<td style="width:24%; text-align:center">작성 날짜 : <%=qna.getCreateDate()%></td>
			</tr>
			<tr>
				<td colspan="4" height="200px"><%=qna.getQnaContent()%></td>
			</tr>
		</table>
		<%
			if(loginMember == null){ // 비로그인, 작성자 아닌 경우
	
			} else if(loginMember.getMemberNo() == qna.getMemberNo()) { // 작성자
		%>	
				<div style="text-align:right">
				<%
					if(commentRow == 0){
				%>	
						<a href="<%=request.getContextPath()%>/updateQnaForm.jsp?qnaNo=<%=qnaNo%>" class="btn btn-light">수정</a>
				<%	
					}
				%>
				<a href="<%=request.getContextPath()%>/deleteQnaForm.jsp?qnaNo=<%=qnaNo%>" class="btn btn-light">삭제</a>
				</div>
		<%
			}
			if(commentRow == 0){
				if(session.getAttribute("loginMember")!= null && loginMember.getMemberLevel() > 0){
		%>			
					<hr>
					<h2>답글 작성</h2>
					<form id="qnaCommentForm" method="post" action="<%=request.getContextPath()%>/admin/insertQnaCommentAction.jsp">
						<table class="table table-bordered">
							<tr>
								<td><textarea class="form-control" rows="5" id="qnaCommentContent" name="qnaCommentContent"></textarea></td>
							</tr>
						</table>
						<div style="text-align:right">
							<button  id="qnaCommentBtn" type="button" class="btn btn-light" >작성 완료</button>
						</div>
						<input type="hidden" name="qnaNo" value="<%=qnaNo%>" readonly="readonly">
						<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>" readonly="readonly">
					</form>
		<%	
				}
			} else if(commentRow == 1){
		%>
				<hr>
				<h2>QnA 답글</h2>
				<table class="table table-bordered">
					<tr>
						<td style="width:7%; text-align:left">관리자<%=qnaComment.getMemberNo()%></td>
					</tr>
					<tr>
						<td height="200px"><%=qnaComment.getQnaCommentContent()%></td>
					</tr>
					<tr>
						<td style="width:24%; text-align:right">작성 날짜 : <%=qnaComment.getCreateDate()%></td>
					</tr>
				
				</table>
		<%
			}

		%>
		
	</div>
	<script>
	$('#qnaCommentBtn').click(function(){
		// 버튼을 클릭했을 때
		if($('#qnaCommentContent').val() == '') { // 내용이 공백이면
			alert('내용을 입력하세요');
			return;
		}
		$('#qnaCommentForm').submit(); // <button type="button"> --> <button type="submit">
	});
	</script>
</body>
</html>