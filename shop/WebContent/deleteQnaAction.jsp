<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo") == "") {
		System.out.println("잘못된 QnA 번호");
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	
	// 작성자만 허용 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberNo() != qna.getMemberNo()){
		System.out.println("작성자가 아닙니다");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// QnA 삭제 메소드 호출
	qnaDao.deleteQna(qnaNo);
	// QnA 답글 삭제 메소드 호출
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.deleteQnaComment(qnaNo);
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
	return;
%>