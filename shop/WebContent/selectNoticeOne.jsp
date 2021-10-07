<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	
	// 방어 코드
	if(request.getParameter("noticeNo") == null || request.getParameter("noticeNo") == "") {
		System.out.println("잘못된 공지사항 번호");
		response.sendRedirect(request.getContextPath()+"/selectNoticeList.jsp");
		return;
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
	Member loginMember = (Member)session.getAttribute("loginMember");
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
		<%
			if(session.getAttribute("loginMember") == null){
		%>
				<div style="text-align:right">
					<a href="<%=request.getContextPath()%>/loginForm.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그인</a> <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="btn btn-light" style="width:70pt;height:32pt;">회원가입</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%
			} else if(loginMember.getMemberLevel() < 1){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%		
			} else if(loginMember.getMemberLevel() > 0){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
				</div>
				<!-- 관리자 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<%	
			}
		%>
		<div class="jumbotron">
	         <h1>공지게시판</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<a style="width:7%; text-align:center" href="<%=request.getContextPath()%>/selectNoticeList.jsp" class="btn btn-light">목록</a>
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
	</div>
</body>
</html>