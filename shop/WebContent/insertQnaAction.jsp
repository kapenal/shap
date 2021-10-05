<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() > 0){
		System.out.println("일반계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 디버깅
	System.out.println(request.getParameter("qnaCategory") + " < insertQnaAction param : qnaCategory");
	System.out.println(request.getParameter("qnaTitle") + " < insertQnaAction param : qnaTitle");
	System.out.println(request.getParameter("qnaContent") + " < insertQnaAction param : qnaContent");
	System.out.println(request.getParameter("qnaSecret") + " < insertQnaAction param : qnaSecret");
	System.out.println(request.getParameter("memberNo") + " < insertQnaAction param : memberNo");
	System.out.println(request.getParameter("memberName") + " < insertQnaAction param : memberName");
	// 방어 코드
	if( request.getParameter("qnaCategory") == null || request.getParameter("qnaCategory").equals("") || request.getParameter("qnaTitle") == null || request.getParameter("qnaTitle").equals("") || request.getParameter("qnaContent") == null || request.getParameter("qnaContent").equals("") || request.getParameter("qnaSecret") == null || request.getParameter("qnaSecret").equals("") || request.getParameter("memberNo") == null || request.getParameter("memberNo").equals("") || request.getParameter("memberName") == null || request.getParameter("memberName").equals("")){
		System.out.println("QnA을 다시 작성해주세요");
		response.sendRedirect(request.getContextPath()+"/insertQnaForm.jsp");
		return;
	}
	// 데이터 타입
	Qna qna = new Qna();
	qna.setQnaCategory(request.getParameter("qnaCategory"));
	qna.setQnaTitle(request.getParameter("qnaTitle"));
	qna.setQnaContent(request.getParameter("qnaContent"));
	qna.setQnaSecret(request.getParameter("qnaSecret"));
	qna.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	qna.setMemberName(request.getParameter("memberName"));
	// QnA 추가 메서드 호출
	QnaDao qnaDao = new QnaDao();
	qnaDao.insertQna(qna);
	// 카테고리 목록으로 이동
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
	return;
%>