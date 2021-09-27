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
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int orderScore = Integer.parseInt(request.getParameter("orderScore"));
	String orderCommentContent = request.getParameter("orderCommentContent");
	//  디버깅 코드
	System.out.println(orderNo + " < insertOrderCommentAction param : orderNo");
	System.out.println(ebookNo + " < insertOrderCommentAction param : ebookNo");
	System.out.println(orderScore + " < insertOrderCommentAction param : orderScore");
	System.out.println(orderCommentContent + " < insertOrderCommentAction param : ebookTitle");
	
	// 데이터 타입
	OrderComment orderComment = new OrderComment();
	orderComment.setOrderNo(orderNo);
	orderComment.setEbookNo(ebookNo);
	orderComment.setOrderScore(orderScore);
	orderComment.setOrderCommentContent(orderCommentContent);
	// 후기 입력 메서드 호출
	OrderDao orderDao = new OrderDao();
	orderDao.insertOrderComment(orderComment);
	// 후기 입력 메서드 호출 후 주문 목록으로 이동?
	response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp");
	return;
%>