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
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 검색어
	String searchNoticeTitle = "";
	if(request.getParameter("searchNoticeTitle") != null) {
		searchNoticeTitle = request.getParameter("searchNoticeTitle");
	}
	System.out.println(searchNoticeTitle + "< 검색어");
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 한 페이지에 보여질 리스트의 행 수
	final int ROW_PER_PAGE = 10; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	// 목록 출력 시작
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	System.out.println(beginRow + "< selectNoticeList beginRow");
	// 화면에 보여질 시작 페이지 번호
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	System.out.println(startPage + "< selectNoticeList startPage");
	// 화면에 보여질 마지막 페이지 번호
	int endPage = startPage + displayPage - 1;
	System.out.println(endPage + "< selectNoticeList endPage");
	// 전체 회원 수
	int totalCount = 0;
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = null;
	if(searchNoticeTitle == ""){
		noticeList = noticeDao.selectNoticeList(beginRow, ROW_PER_PAGE);
		totalCount = noticeDao.selectNoticeListAllByTotalPage();
	} else{
		noticeList = noticeDao.selectNoticeListBySearch(beginRow, ROW_PER_PAGE, searchNoticeTitle);
		totalCount = noticeDao.selectNoticeListAllBySearchTotalPage(searchNoticeTitle);
	}
	// 마지막 페이지 구하는 호출
	int lastPage = noticeDao.selectNoticeListAllByLastPage(totalCount, ROW_PER_PAGE);
	System.out.println(lastPage + "< selectNoticeList lastPage");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectNoticeList.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<!-- 관리자 메뉴 인클루드 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>공지게시판 관리</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>공지사항</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:7%; text-align:center">No</th>
					<th>제목</th>
					<th style="width:12%; text-align:center">작성자</th>
					<th style="width:18%; text-align:center">올린 날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Notice n : noticeList){
				%>
						<tr>
							<td style="text-align:center"><%=n.getNoticeNo()%></td>
							<td><a href="<%=request.getContextPath()%>/admin/selectNoticeOne.jsp?noticeNo=<%=n.getNoticeNo()%>"><%=n.getNoticeTitle()%></a></td>
							<td style="text-align:center"><%=n.getMemberNo()%></td>
							<td style="text-align:center"><%=n.getCreateDate()%></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<div style="text-align:right"><a href="<%=request.getContextPath()%>/admin/insertNoticeForm.jsp" class="btn btn-light">공지사항 작성</a></div>
		<div>
			<form method="post" action="<%=request.getContextPath()%>/admin/selectNoticeList.jsp">
				<table>
					<tr>
						<td>공지사항 검색</td>
						<td><input type="text" name="searchNoticeTitle"></td>
						<td><button type="submit">검색</button></td>
					</tr>
				</table>
			</form>
		</div>
		<br>
		<%
			if(totalCount > ROW_PER_PAGE && currentPage > 1 ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?searchNoticeTitle=<%=searchNoticeTitle%>">처음으로</a>
		<%
			}
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(currentPage > displayPage){
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=startPage-1%>&searchNoticeTitle=<%=searchNoticeTitle%>">이전</a>
		<%
			}
			// 페이지 번호 버튼
			for(int i=startPage; i<=endPage; i++) {
				if(currentPage == i){
		%>
					<a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=i%>&searchNoticeTitle=<%=searchNoticeTitle%>"><%=i%></a>
		<%	
			} else if(endPage<=lastPage) {
		%>
				<a class="btn btn-info" class="text-warning" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=i%>&searchNoticeTitle=<%=searchNoticeTitle%>"><%=i%></a>
		<%
			} else if(endPage>lastPage) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=i%>&searchNoticeTitle=<%=searchNoticeTitle%>"><%=i%></a>
		<%	
			}
				// 카테고리 없을시 숫자 페이징이 10까지 나오는 것을 lastPage==0 을 if문에 or로 추가하여 이슈 해결
				if(i == lastPage || lastPage == 0) {	
					break;
				}
			}
			//다음 버튼
			// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
			if(endPage < lastPage) {
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=startPage+displayPage%>&searchNoticeTitle=<%=searchNoticeTitle%>">다음</a>
		<%
			}
			// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
			if(totalCount > ROW_PER_PAGE && currentPage != lastPage ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp?currentPage=<%=lastPage%>&searchNoticeTitle=<%=searchNoticeTitle%>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>