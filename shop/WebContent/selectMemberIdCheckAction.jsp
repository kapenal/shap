<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="dao.*"%>
<%
	// memberIdCheck값이 공백, null인지 유효성 검사
	if(request.getParameter("memberIdCheck") == null || request.getParameter("memberIdCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 파라메터값 받기
	String memberIdCheck = request.getParameter("memberIdCheck");
	// 디버깅
	System.out.println(memberIdCheck + " < selectMeberId param : memberIdCheck");
	// 아이디 중복 검사 메서드 호출
	MemberDao memberDao = new MemberDao(); 	
	String result = memberDao.selectMemberId(memberIdCheck);
	
	if(result == null) {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?memberIdCheck="+memberIdCheck);	
	}else {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?idCheckResult=This ID is already taken");
	}
%>