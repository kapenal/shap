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
	
	// 방어 코드
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo") == "") {
		System.out.println("잘못된 공지사항 번호");
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
		return;
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectNoticeOne.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
		</div>
		<!-- 관리자 메뉴 인클루드 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>공지게시판 관리</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<a style="width:7%; text-align:center" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp" class="btn btn-light">목록</a>
		<table class="table table-bordered">
			<tr>
				<td style="width:7%; text-align:center">No.<%=notice.getNoticeNo()%></td>
				<td><%=notice.getNoticeTitle()%></td>
				<td style="width:24%; text-align:center">작성 날짜 : <%=notice.getCreateDate()%></td>
			</tr>
			<tr>
				<td colspan="3" height="200px"><%=notice.getNoticeContent()%></td>
			</tr>
		</table>
		<div style="text-align:right">
			<a href="<%=request.getContextPath()%>/admin/updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-light">수정</a>
			<a href="<%=request.getContextPath()%>/admin/deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn btn-light">삭제</a>
		</div>
	</div>
</body>
</html>