<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<% 	
	// 인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("memberNo")==null || request.getParameter("searchMemberId")==null || request.getParameter("currentPage")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp?searchMemberId="+request.getParameter("searchMemberId")+"&currentPage="+request.getParameter("currentPage"));
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String searchMemberId = request.getParameter("searchMemberId");
	int currentPage = Integer.parseInt(request.getParameter("currentPage"));
	// 디버깅
	System.out.println(memberNo + " < deleteMember.jsp param : memberNo");
	
	MemberDao memberDao = new MemberDao();
	memberDao.deleteMemberByKey(memberNo);
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp?searchMemberId="+searchMemberId+"&currentPage="+currentPage);
	return;
%>