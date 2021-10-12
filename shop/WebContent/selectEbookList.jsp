<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}	
	// 검색어
	String searchEbookTitle = "";
	if(request.getParameter("searchEbookTitle") != null) {
		searchEbookTitle = request.getParameter("searchEbookTitle");
	}
	System.out.println(searchEbookTitle + "< 검색어");
	EbookDao ebookDao = new EbookDao();
	// 선택한 카테고리
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	System.out.println(categoryName + "< 선택된 카테고리");
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
	// 전체 회원 수
	int totalCount = ebookDao.selectEbookListAllByTotalPage(searchEbookTitle);
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	// 한 페이지에 보여질 책의 수
	final int ROW_PER_PAGE = 20; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
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
	// 회원 목록 출력 메서드 호출
	if(categoryName.equals("") == true) { // 카테고리 없을때
		ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE, searchEbookTitle);
		totalCount = ebookDao.selectEbookListAllByTotalPage(searchEbookTitle);
	}else { // 카테고리 있을때
		ebookList = ebookDao.selectEbookListByCategory(beginRow, ROW_PER_PAGE, categoryName, searchEbookTitle);
		totalCount = ebookDao.selectEbookListAllByCategoryNameTotalPage(categoryName, searchEbookTitle);
	}
	
	// 마지막 페이지 구하는 호출
	int lastPage = ebookDao.selectEbookListAllByLastPage(totalCount, ROW_PER_PAGE);
	System.out.println(lastPage + "< index lastPage");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectEbookList.jsp</title>
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
	         <h1>전자책 목록</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>전자책 목록</h2>
		</div>
		<!--  전자책 목록 출력 : 카테고리별 출력 -->
		<form action="<%=request.getContextPath()%>/selectEbookList.jsp">
			<select name="categoryName">
				<option value="">전체목록</option>
				<%
					for(Category c : categoryList){
				%>
					<option value="<%=c.getCategoryName()%>"><%=c.getCategoryName()%></option>
				<%	
					}
				%>
			</select>
			<button type="submit">선택</button>
			<input type="hidden" name="searchEbookTitle" value="<%=searchEbookTitle%>">
		</form>
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
			<form method="post" action="<%=request.getContextPath()%>/selectEbookList.jsp?categoryName=<%=categoryName%>">
				<table>
					<tr>
						<td>제목 검색</td>
						<td><input type="text" name="searchEbookTitle" value=<%=searchEbookTitle%>></td>
						<td><button type="submit">검색</button></td>
					</tr>
				</table>
			</form>
		</div>
		<br>
		<%
			if(totalCount > ROW_PER_PAGE && currentPage > 1 ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=1&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>">처음으로</a>
		<%
			}
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(currentPage > displayPage){
		%>
			<a class="btn btn-info" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=startPage-1%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>">이전</a>
		<%
			}
			// 페이지 번호 버튼
			for(int i=startPage; i<=endPage; i++) {
				if(currentPage == i){
		%>
					<a class="btn btn-primary" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
		<%	
			} else if(endPage<=lastPage) {
		%>
				<a class="btn btn-info" class="text-warning" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
		<%
			} else if(endPage>lastPage) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>"><%=i%></a>
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
			<a class="btn btn-info" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=startPage+displayPage%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>">다음</a>
		<%
			}
			// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
			if(totalCount > ROW_PER_PAGE && currentPage != lastPage ) {
		%>
				<a class="btn btn-info" href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=lastPage%>&categoryName=<%=categoryName%>&searchEbookTitle=<%=searchEbookTitle%>">끝으로</a>
		<%
			}
		%>
	</div>
</body>
</html>