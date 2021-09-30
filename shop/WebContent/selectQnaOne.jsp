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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectQnaOne.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<%
			Member loginMember = (Member)session.getAttribute("loginMember");
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
			if(qna.getQnaSecret().equals("Y")){
				if(loginMember.getMemberNo() == qna.getMemberNo() ){
		%>
					<div style="text-align:right">
					<a href="<%=request.getContextPath()%>/updateQnaForm.jsp?qnaNo=<%=qnaNo%>" class="btn btn-light">수정</a>
					<a href="<%=request.getContextPath()%>/deleteQnaForm.jsp?qnaNo=<%=qnaNo%>" class="btn btn-light">삭제</a>
					</div>
		<%	
				}
			}
		%>
	</div>
</body>
</html>