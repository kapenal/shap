<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인증 방어 코드 : 로그인 후 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	// 사용자의 기존 세션을 새로운 세션으로 갱신
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/index.jsp");
%>