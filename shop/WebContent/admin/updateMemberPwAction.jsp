<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 디버깅
		System.out.println(request.getParameter("memberNo") + " < updateMemberPwAction.jsp param : memberNo");
		System.out.println(request.getParameter("memberNewPw") + " < updateMemberPwAction.jsp param : memberNewPw");
		System.out.println(request.getParameter("searchMemberId") + " < updateMemberPwAction.jsp param : searchMemberId");
		System.out.println(request.getParameter("currentPage") + " < updateMemberPwAction.jsp param : currentPage");
	// 방어 코드
	if(request.getParameter("memberNo")==null || request.getParameter("memberNewPw")==null ||  request.getParameter("memberNewPw")=="" ||request.getParameter("searchMemberId")==null || request.getParameter("currentPage")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp?searchMemberId="+request.getParameter("searchMemberId")+"&currentPage="+request.getParameter("currentPage"));
		return;
	}	
	
	String searchMemberId = request.getParameter("searchMemberId");
	int currentPage = Integer.parseInt(request.getParameter("currentPage"));
	
	Member paramMember = new Member();
	paramMember.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	paramMember.setMemberPw(request.getParameter("memberNewPw"));
	
	MemberDao memberDao = new MemberDao();
	memberDao.updateMemberPwByAdmin(paramMember);
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp?searchMemberId="+searchMemberId+"&currentPage="+currentPage);
	return;
%>