<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*"%>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	Member loginMember = (Member)session.getAttribute("loginMember");
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	
	// 주문 출력
	OrderDao orderDao = new OrderDao();
	ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo());
	
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	// 주문 기록이 있는지 확인
	int orderClear = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectOrderListByMember</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
		</div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>내 주문</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>주문 목록</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>주문 번호</th>
					<th>책 제목</th>
					<th>가격</th>
					<th>주문 날짜</th>
					<th>구매자ID</th>
					<th>상세주문내역</th>
					<th>책 후기</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(OrderEbookMember oem : list){
						orderClear++;
				%>
						<tr>
							<td><%=oem.getOrder().getOrderNo()%></td>
							<td><a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a></td>
							<td><%=oem.getOrder().getOrderPrice()%></td>
							<td><%=oem.getOrder().getCreateDate()%></td>
							<td><%=oem.getMember().getMemberId()%></td>
							<td><a href="<%=request.getContextPath()%>/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>">상세주문내역</a></td>
							<%
								if(orderCommentDao.orderCommentCheck(oem.getOrder().getOrderNo()) == 0){
							%>	
									<td><a href="<%=request.getContextPath()%>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>&ebookNo=<%=oem.getEbook().getEbookNo()%>&ebookTitle=<%=oem.getEbook().getEbookTitle()%>">후기 작성하러 가기</a></td>
							<%	
								} else{
							%>
									<td>후기 작성 완료</td>
							<%		
								}
							%>
						</tr>
				<%
					}
					if(orderClear == 0){
				%>
						<tr>
							<td style="text-align:center" colspan="7">주문 기록이 없습니다</td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>