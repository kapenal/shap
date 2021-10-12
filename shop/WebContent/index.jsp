<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	// 검색어
	String searchEbookTitle = "";
	if(request.getParameter("searchEbookTitle") != null) {
		searchEbookTitle = request.getParameter("searchEbookTitle");
	}
	System.out.println(searchEbookTitle + "< 검색어");
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	EbookDao ebookDao = new EbookDao();
	
	// 전체 회원 수
	int totalCount = ebookDao.selectEbookListAllByTotalPage(searchEbookTitle);
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	// 한 페이지에 보여질 책의 수
	final int ROW_PER_PAGE = 10; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	System.out.println(beginRow + "< index beginRow");
	// 화면에 보여질 시작 페이지 번호, (currentPage - 1)을 하는 이유는 현재페이지가 10일시에도 startPage가 1이기 위해서
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	System.out.println(startPage + "< index startPage");
	// 화면에 보여질 마지막 페이지 번호, -1을 하는 이유는 페이지 번호의 갯수가 10개이기 때문에 statPage에서 더한 1을 빼준다
	int endPage = startPage + displayPage - 1;
	System.out.println(endPage + "< index endPage");
	
	// 전자책 목록 메서드 출력
	ArrayList<Ebook> ebookList = null;
	// 전체 전자책 목록 
	ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE, searchEbookTitle);
	// 상위 인기 목록 5개(주문 순)
	ArrayList<Ebook> popularEbookList = ebookDao.selectPopularEbookList();
	// 신상 목록 5개
	ArrayList<Ebook> newProductEbookList = ebookDao.selectNewProductEbookList();
	// 최근 공지사항 5개
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> newNoticeList = noticeDao.selectNewNoticeList();
	
	// 마지막 페이지 구하는 호출
	int lastPage = ebookDao.selectEbookListAllByLastPage(totalCount, ROW_PER_PAGE);
	System.out.println(lastPage + "< index lastPage");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<%
			Member loginMember = (Member)session.getAttribute("loginMember");
			if(session.getAttribute("loginMember") == null){
		%>
				<div style="text-align:right">
					<a href="<%=request.getContextPath()%>/loginForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그인</a> <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none">회원가입</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%
			} else if(loginMember.getMemberLevel() < 1){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
				</div>
				<!-- 메인 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<%		
			} else if(loginMember.getMemberLevel() > 0){
		%>
				<div style="text-align:right">
					<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
				</div>
				<!-- 관리자 메뉴 include 절대 주소 -->
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<%	
			}
		%>
		<div class="jumbotron">
	         <h1>메인페이지</h1>
		</div>
		<div>
		<%
			if(session.getAttribute("loginMember") == null){
		%>
			<!-- 로그인 실패 or 전 -->
			<div><a href="<%=request.getContextPath()%>/loginForm.jsp" class="btn btn-info">로그인</a></div>
			<br>
			<div><a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="btn btn-info">회원가입</a></div>
		<%
			}else {
		%>
			<!-- 로그인 성공 or 유지 -->
			<div><h2><span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다.</h2></div>
			<br>
		<%
				if(loginMember.getMemberLevel() > 0){
		%>
					<div><a href ="<%=request.getContextPath()%>/admin/adminIndex.jsp" class="btn btn-info">관리자 페이지가기</a></div>
					<br>
		<%
				}
		%>
			<a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-info">로그아웃</a>
			<a href="<%=request.getContextPath()%>/selectMemberOne.jsp?memberNo=<%=loginMember.getMemberNo()%>" class="btn btn-info">회원정보</a>
			<a href="<%=request.getContextPath()%>/selectOrderListByMember.jsp" class="btn btn-info">내 주문</a>
			<a href="<%=request.getContextPath()%>/selectQnaListByMember.jsp" class="btn btn-info">내 QnA</a>
		<%
			}
		%>
		</div>
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
		<br>
		<!-- 상품 목록  -->
		<div>
			<h2>신상품 목록</h2>
		</div>
		<table class="table table-bordered">
			<tr>
				<%
					for(Ebook e: newProductEbookList){
				%>
						<td>
							<div>
								<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="200"></a>
							</div>
							<div><a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><%=e.getEbookTitle()%></a></div>
							<div><%=e.getEbookPrice()%>원</div>
						</td>
				<%
					}
				%>
			</tr>
		</table>
		<br>
		<div>
			<h2>인기 전자책 목록</h2>
		</div>
		<table class="table table-bordered">
			<tr>
				<%
					for(Ebook e: popularEbookList){
				%>
						<td>
							<div>
								<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="200"></a>
							</div>
							<div><a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><%=e.getEbookTitle()%></a></div>
							<%
								if(e.getEbookState().equals("품절")){
							%>	
									품절
							<%	
								} else if(e.getEbookState().equals("절판")){
							%>	
									절판
							<%	
								} else{
							%>	
									<div><%=e.getEbookPrice()%>원</div>
							<%	
								}
							%>
						</td>
				<%
					}
				%>
			</tr>
		</table>
		<br>
		<div>
			<h2>전체 전자책 목록</h2>
		</div>
		<table class="table table-bordered">
			<tr>
				<%
					int j = 0;
					for(Ebook e : ebookList){
				%>
						<td>
							<div>
								<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="200"></a>
							</div>
							<div><a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>"><%=e.getEbookTitle()%></a></div>
							<%
								if(e.getEbookState().equals("품절")){
							%>	
									품절
							<%	
								} else if(e.getEbookState().equals("절판")){
							%>	
									절판
							<%	
								} else{
							%>	
									<div><%=e.getEbookPrice()%>원</div>
							<%	
								}
							%>
							
						</td>
				<%
						j+=1;
						if(j%5 == 0){
				%>
						<tr></tr>
				<%		
						}
					}
				%>
			</tr>
		</table>
		<div>
			<form method="post" action="<%=request.getContextPath()%>/index.jsp">
				<table>
					<tr>
						<td>제목 검색</td>
						<td><input type="text" name="searchEbookTitle" value="<%=searchEbookTitle%>"></td>
						<td><button type="submit">검색</button></td>
					</tr>
				</table>
			</form>
		</div>
		<br>
		<%
			if(totalCount > ROW_PER_PAGE && currentPage > 1 ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/index.jsp?currentPage=1&searchEbookTitle=<%=searchEbookTitle%>">처음으로</a>
		<%
			}
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(currentPage > displayPage){
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=startPage-1%>&searchEbookTitle=<%=searchEbookTitle%>">이전</a>
		<%
			}
			// 페이지 번호 버튼
			for(int i=startPage; i<=endPage; i++) {
				if(currentPage == i){
		%>
					<a class="btn btn-primary" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
		<%	
			} else if(endPage<=lastPage) {
		%>
				<a class="btn btn-info" class="text-warning" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
		<%
			} else if(endPage>lastPage) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
		<%	
			}
				if(i == lastPage || lastPage == 0) {	
					break;
				}
			}
			//다음 버튼
			// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
			if(endPage < lastPage) {
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=startPage+displayPage%>&searchEbookTitle=<%=searchEbookTitle%>">다음</a>
		<%
			}
			// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
			if(totalCount > ROW_PER_PAGE && currentPage != lastPage ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=lastPage%>&searchEbookTitle=<%=searchEbookTitle%>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>