<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("ebookNo") == null){
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp?");
		return;
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// 디버깅
	System.out.println(ebookNo + " < updateEbookPriceForm param : ebookNo");
	
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>가격 수정</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<form action="<%=request.getContextPath()%>/admin/updateEbookPriceAction.jsp" method="post" > 
		   <div>넘버</div>
		   <input type="text" name="ebookNo" readonly="readonly" value="<%=ebook.getEbookNo()%>">
		   <div>책 이름</div>
		   <input type="text" name="ebookTitle" readonly="readonly" value="<%=ebook.getEbookTitle()%>">
		   <div>변경할 가격</div>
		   <input type="text" name="ebookPrice">
		   <button type="submit" class="btn btn-light">가격 수정</button>
	   </form>
	</div>
</body>
</html>