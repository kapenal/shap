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
	System.out.println(request.getParameter("noticeNo") + " < updateNoticeAction param : noticeNo");
	System.out.println(request.getParameter("noticeTitle") + " < updateNoticeAction param : noticeTitle");
	System.out.println(request.getParameter("noticeContent") + " < updateNoticeAction param : noticeContent");
	// 방어 코드
	if( request.getParameter("noticeTitle") == null || request.getParameter("noticeTitle").equals("") || request.getParameter("noticeContent") == null || request.getParameter("noticeContent").equals("")){
		System.out.println("공지사항을 다시 수정해주세요");
		response.sendRedirect(request.getContextPath()+"/admin/updateNoticeForm.jsp");
		return;
	}
	// 데이터 타입
	Notice notice = new Notice();
	notice.setNoticeNo(Integer.parseInt(request.getParameter("noticeNo")));
	notice.setNoticeTitle(request.getParameter("noticeTitle"));
	notice.setNoticeContent(request.getParameter("noticeContent"));
	
	NoticeDao noticeDao = new NoticeDao();
	noticeDao.updateNotice(notice);
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeOne.jsp?noticeNo="+notice.getNoticeNo());
	return;
%>