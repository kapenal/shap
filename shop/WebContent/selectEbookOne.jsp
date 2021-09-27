<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("ebookNo") == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	System.out.println(ebook.getEbookImg());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectEbookOne.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>상세 보기</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<table class="table table-bordered">
		<tr>
			<td><%=ebook.getEbookNo()%></td>
			<td colspan="2"><%=ebook.getEbookIsbn() %>
			<td><%=ebook.getCategoryName()%></td>
			
		</tr>
		<tr>
			<td>제목 : <%=ebook.getEbookTitle()%></td>
			<td>저자 : <%=ebook.getEbookAuthor()%></td>
			<td><%=ebook.getEbookPageCount()%>페이지</td>
			<td><%=ebook.getEbookPrice()%>원</td>
		</tr>
		<tr>
			<td><img src="<%=request.getContextPath()%>/image/<%=ebook.getEbookImg()%>" width="200" height="200"></td>
			<td colspan="3"><%=ebook.getEbookSummary()%></td>
		</tr>
		</table>
	</div>
</body>
</html>