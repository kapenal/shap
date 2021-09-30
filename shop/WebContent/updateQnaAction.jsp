<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("qnaNo") == null || request.getParameter("qnaNo") == "" || request.getParameter("qnaTitle") == null || request.getParameter("qnaTitle") == "" || request.getParameter("qnaContent") == null || request.getParameter("qnaContent") == "" || request.getParameter("qnaCategory") == null || request.getParameter("qnaCategory") == "" || request.getParameter("qnaSecret") == null || request.getParameter("qnaSecret") == "") {
		System.out.println("잘못 입력했습니다.");
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// 작성자 확인용
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	
	// 작성자만 허용 방어코드
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberNo() != qna.getMemberNo()){
		System.out.println("작성자가 아닙니다");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 데이터 타입
	Qna qnaParam = new Qna();
	qnaParam.setQnaNo(Integer.parseInt(request.getParameter("qnaNo")));
	qnaParam.setQnaCategory(request.getParameter("qnaCategory"));
	qnaParam.setQnaTitle(request.getParameter("qnaTitle"));
	qnaParam.setQnaContent(request.getParameter("qnaContent"));
	qnaParam.setQnaSecret(request.getParameter("qnaSecret"));
	
	qnaDao.updateQna(qnaParam);
	response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qnaNo="+qnaNo);
	return;
%>