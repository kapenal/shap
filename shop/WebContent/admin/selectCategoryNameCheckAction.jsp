<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
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
	// categoryName값이 공백, null인지 유효성 검사
	if(request.getParameter("categoryCheckName") == null || request.getParameter("categoryCheckName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	// 파라메터값 받기
	String categoryCheckName = request.getParameter("categoryCheckName");
	// 디버깅
	System.out.println(categoryCheckName + " < selectCategoryNameCheck param : categoryName");
	// 카테고리 중복 검사 메서드 호출
	CategoryDao categoryDao = new CategoryDao(); 	
	String result = categoryDao.selectCategoryCheck(categoryCheckName);
	System.out.println(result);
	if(result == null) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryCheckName="+categoryCheckName);	
	}else {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?idCheckResult=null");
	}
%>