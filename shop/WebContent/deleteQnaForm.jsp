<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//한글 깨짐 방지
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
<title>deleteQnaForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>QnA 삭제</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div style="text-align:center">
			<h2>QnA <%=qna.getQnaTitle()%>를 삭제하겠습니까?</h2>
		</div>
		<div style="text-align:center">
			<a class="btn btn-danger" href="<%=request.getContextPath()%>/deleteQnaAction.jsp?qnaNo=<%=qnaNo%>">삭제</a>
		</div>
	</div>
</body>
</html>