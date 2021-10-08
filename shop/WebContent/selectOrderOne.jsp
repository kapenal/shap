<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		System.out.println("로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/selectOrderList.jsp?");
		return;
	}
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	OrderDao orderDao = new OrderDao();
	OrderEbookMember oem = orderDao.selectOrderNoOne(orderNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectOrderOne.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>상세 주문내역</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<table class="table table-bordered">
			<tr>
				<td>주문 번호 : <%=oem.getOrder().getOrderNo()%></td>
				<td>가격 : <%=oem.getOrder().getOrderPrice()%>
				<td>주문 날짜 : <%=oem.getOrder().getCreateDate()%></td>
				
			</tr>
			<tr>
				<td>책번호 : <%=oem.getEbook().getEbookNo()%></td>
				<td>제목 : <a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a></td>
				<td><img src="<%=request.getContextPath()%>/image/<%=oem.getEbook().getEbookImg()%>" width="200" height="200"></td>
			</tr>
		</table>
	</div>
</body>
</html>