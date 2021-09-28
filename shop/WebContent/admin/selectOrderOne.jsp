<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
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
	if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/admin/selectOrderList.jsp?");
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
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
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
				<td>제목 : <a href="<%=request.getContextPath()%>/admin/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a></td>
				<td><img src="<%=request.getContextPath()%>/image/<%=oem.getEbook().getEbookImg()%>" width="200" height="200"></td>
			</tr>
			<tr>
				
				<td colspan="3">구매자 아이디 : <a href="<%=request.getContextPath()%>/admin/selectMemberList.jsp?searchMemberId=<%=oem.getMember().getMemberId()%>"><%=oem.getMember().getMemberId()%></a></td>
			</tr>
		</table>
	</div>
</body>
</html>