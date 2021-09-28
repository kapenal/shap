<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 파라메터값 받기
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	int orderPrice = Integer.parseInt(request.getParameter("orderPrice"));
	//  디버깅 코드
	System.out.println(ebookNo + " < insertOrderAction param : ebookNo");
	System.out.println(memberNo + " < insertOrderAction param : memberNo");
	System.out.println(orderPrice + " < insertOrderAction param : orderPrice");
	// 데이터 타입
	Order order = new Order();
	order.setEbookNo(ebookNo);
	order.setMemberNo(memberNo);
	order.setOrderPrice(orderPrice);
	// 주문 입력 메서드 호출
	OrderDao orderDao = new OrderDao();
	orderDao.insertOrder(order);
	response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp");
	return;
%>