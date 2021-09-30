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
	System.out.println(request.getParameter("qnaNo") + " < insertQnaCommentAction param : qnaNo");
	System.out.println(request.getParameter("qnaCommentContent") + " < insertQnaCommentAction param : qnaCommentContent");
	System.out.println(request.getParameter("memberNo") + " < insertQnaCommentAction param : memberNo");
	// 방어 코드
	if( request.getParameter("qnaNo") == null || request.getParameter("qnaNo").equals("") || request.getParameter("qnaCommentContent") == null || request.getParameter("qnaCommentContent").equals("") || request.getParameter("memberNo") == null || request.getParameter("memberNo").equals("")){
		System.out.println("답글을 다시 작성해주세요");
		response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qnaNo="+request.getParameter("qnaNo"));
		return;
	}
	// 데이터 타입
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaNo(Integer.parseInt(request.getParameter("qnaNo")));
	qnaComment.setQnaCommentContent(request.getParameter("qnaCommentContent"));
	qnaComment.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	// 공지사항 추가 메서드 호출
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.insertQnaComment(qnaComment);
	// 공지게시판으로 이동
	response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qnaNo="+qnaComment.getQnaNo());
	return;
%>