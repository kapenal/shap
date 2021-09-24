<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- start : mainMenu include -->
		<div>
			<!-- 절대주소 /으로 시작-->
		<!-- <jsp:include page="/partial/mainMenu.jsp"></jsp:include> --> 
		</div>
		<!-- end : mainMenu include -->
		<div class="jumbotron">
	         <h1>메인 페이지</h1>
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
				
				Member loginMember = (Member)session.getAttribute("loginMember");
		%>
			<!-- 로그인 성공 or 유지 -->
			<div><h2><span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다.</h2></div>
			<br>
		<%
				if(loginMember.getMemberLevel() > 0){
		%>
					<!-- 관리자 페이지로 가는 링크 -->
					<div><a href ="<%=request.getContextPath()%>/admin/adminIndex.jsp" class="btn btn-info">관리자 페이지가기</a></div>
					<br>
		<%
				}
		%>
			<div><a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-info">로그아웃</a></div>
		<%
			}
		%>
		</div>
		<!-- 상품 목록  -->
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
			
			// 한 페이지에 보여질 리스트의 행 수
			final int ROW_PER_PAGE = 20; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
			int beginRow = (currentPage - 1) * ROW_PER_PAGE;
			System.out.println(beginRow + "< index beginRow");
			// 전체 회원 수
			int totalCount = 0;
			// 화면에 보여질 페이지 번호의 갯수
			int displayPage = 10;
			System.out.println(displayPage + "index displayPage");
			// 화면에 보여질 시작 페이지 번호
			// (currentPage - 1)을 하는 이유는 현재페이지가 10일시에도 startPage가 1이기 위해서
			int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
			System.out.println(startPage + "< index startPage");
			// 화면에 보여질 마지막 페이지 번호
			// -1을 하는 이유는 페이지 번호의 갯수가 10개이기 때문에 statPage에서 더한 1을 빼준다
			int endPage = startPage + displayPage - 1;
			System.out.println(endPage + "< index endPage");
			// 전자책 목록 메서드 출력
			ArrayList<Ebook> ebookList = null;
			ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE, searchEbookTitle);
			totalCount = ebookDao.selectEbookListAllByTotalPage(searchEbookTitle);
			// 마지막 페이지 구하는 호출
			int lastPage = ebookDao.selectEbookListAllByLastPage(totalCount, ROW_PER_PAGE);
			System.out.println(lastPage + "< index lastPage");
			
		%>
		<br>
		<div>
			<h2>전자책 목록</h2>
		</div>
		<table class="table table-bordered">
			<tr>
				<%
					int j = 0;
					for(Ebook e : ebookList){
				%>
						<td>
							<div>
								<img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="200">
							</div>
							<div><%=e.getEbookTitle()%></div>
							<div><%=e.getEbookPrice()%> 원</div>
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
						<td><input type="text" name="searchEbookTitle"></td>
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
				// 카테고리 없을시 숫자 페이징이 10까지 나오는 것을 lastPage==0 을 if문에 or로 추가하여 이슈 해결
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