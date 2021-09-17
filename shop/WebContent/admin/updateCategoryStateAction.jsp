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
	// 디버깅
	System.out.println(request.getParameter("categoryName") + " < updateCategoryStateAction param : categoryName");
	System.out.println(request.getParameter("categoryState") + " < updateCategoryStateAction param : categoryState");
	//방어 코드
	if( request.getParameter("categoryName") == null || request.getParameter("categoryName").equals("") || request.getParameter("categoryState") == null || request.getParameter("categoryState").equals("")){
		System.out.println("사용 여부를 정확히 입력하세요.");
		response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
		return;
	}
	// 데이터 타입
	Category category = new Category();
	category.setCategoryName(request.getParameter("categoryName"));
	category.setCategoryState(request.getParameter("categoryState"));
	// 카테고리 상태 변경 메서드 호출
	CategoryDao categoryDao = new CategoryDao();
	categoryDao.updateCategoryState(category);
	// 회원가입 insertMeber 메서드 호출 후 카테고리 목록으로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
	return;
%>