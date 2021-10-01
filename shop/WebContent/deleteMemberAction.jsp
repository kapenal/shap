<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("memberNo") == null || request.getParameter("memberNo") == "") {
		System.out.println("잘못된 접근입니다");
		response.sendRedirect(request.getContextPath()+"/selectMemberOne.jsp?memberNo="+request.getParameter("memberNo"));
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// 로그인한 회원만 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 회원 탈퇴 메소드 호출
	MemberDao memberDao = new MemberDao();
	memberDao.deleteMemberByKey(memberNo);
	response.sendRedirect(request.getContextPath()+"/logOut.jsp");
	return;
%>