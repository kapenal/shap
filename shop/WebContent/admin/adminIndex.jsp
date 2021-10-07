<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
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
	
	// 최근 공지사항 5개
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> newNoticeList = noticeDao.selectNewNoticeList();
	// 최근 답글 안달린 QnA 5개
	QnaDao qnaDao = new QnaDao();
	ArrayList<Qna> newQnaList = qnaDao.selectNewQnAList();
	// 댓글단 QnA 확인용
	int qnaClear = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>adminIndex.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
		</div>
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>관리자 페이지</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div><h2><span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다.</h2></div>
		<br>
		<div>
			<h2>공지 사항</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:7%; text-align:center">No</th>
					<th>공지 제목</th>
					<th style="width:18%; text-align:center">작성 날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Notice n: newNoticeList){
				%>
						<tr>
							<td style="text-align:center"><%=n.getNoticeNo()%></td>
							<td><a href="<%=request.getContextPath()%>/selectNoticeOne.jsp?noticeNo=<%=n.getNoticeNo()%>"><%=n.getNoticeTitle()%></a></td>
							<td style="text-align:center"><%=n.getCreateDate()%></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<hr>
		<h2>최근 QnA</h2>
		<div style="text-align:right"><a href="<%=request.getContextPath()%>/selectQnaList.jsp" class="btn btn-light">QnA게시판가기</a></div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:7%; text-align:center">No</th>
					<th style="width:12%; text-align:center">카테고리</th>
					<th>제목</th>
					<th style="width:10%; text-align:center">작성자</th>
					<th style="width:18%; text-align:center">작성 날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Qna q : newQnaList){
						qnaClear ++;
				%>
						<tr>
							<td style="text-align:center"><%=q.getQnaNo()%></td>
							<td style="text-align:center"><%=q.getQnaCategory()%></td>
							<td><a href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaTitle()%></a></td>		
							<td style="text-align:center"><%=q.getMemberNo()%></td>
							<td style="text-align:center"><%=q.getCreateDate()%></td>
						</tr>
				<%
					}
					if(qnaClear == 0){
				%>
						<tr>
							<td style="text-align:center" colspan="5">새로운 QnA가 없습니다</td>
						</tr>
				<%
					}
				%>
					
			</tbody>
		</table>
	</div>
</body>
</html>