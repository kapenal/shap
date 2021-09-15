<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%	
	// 인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 한 페이지에 보여질 리스트의 행 수
	final int ROW_PER_PAGE = 10; // 상수 : 10으로 초기화와 동시에 끝까지 변하지 않는 수, 상수는 대문자로 표현
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	// MemberDao 객체 
	MemberDao memberDao = new MemberDao();
	ArrayList<Member> memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);
	int totalCount = memberDao.selectMemberListAllByTotalPage();
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	System.out.println(currentPage + "currentPage갯수");
	// 화면에 보여질 시작 페이지 번호
	// (currentPage - 1)을 하는 이유는 현재페이지가 10일시에도 startPage가 1이기 위해서
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	// 화면에 보여질 마지막 페이지 번호
	// -1을 하는 이유는 페이지 번호의 갯수가 10개이기 때문에 statPage에서 더한 1을 빼준다
	int endPage = startPage + displayPage - 1;
	// 마지막 페이지 구하는 호출
	int lastPage = memberDao.selectMemberListAllByLastPage(totalCount, ROW_PER_PAGE);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectMemberList.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>회원 목록</h1>
		</div>
		<div>
			<h2>회원 목록</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>번호</th>
					<th>아이디</th>
					<th>권한 레벨</th>
					<th>이름</th>
					<th>나이</th>
					<th>성별</th>
					<th>최근 갱신 날짜</th>
					<th>계정 생성 날짜</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Member m : memberList){
				%>
						<tr>
							<td><%=m.getMemberNo()%></td>
		
							<td><%=m.getMemberId()%></td>
							<td>
								<%
								if(m.getMemberLevel() == 0) {
								%>
									<span>일반회원</span>
								<%		
								} else if(m.getMemberLevel() == 1) {
								%>
									<span>관리자</span>
								<%
								}
								%>
							</td>
							<td><%=m.getMemberName()%></td>
							<td><%=m.getMemberAge()%></td>
							<td><%=m.getMemberGender()%></td>
							<td><%=m.getUpdateDate()%></td>
							<td><%=m.getCreatDate()%></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
<%
		if(totalCount > ROW_PER_PAGE && currentPage > 1 ){
%>
			<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=1">처음으로</a>
<%
		}
		// 이전 버튼
		// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
		if(currentPage > displayPage){
%>
		<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=<%=currentPage-displayPage%>">이전</a>
<%
}
		// 페이지 번호 버튼
		for(int i=startPage; i<=endPage; i++) {
			if(endPage<=lastPage){
%>
				<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=<%=i%>"><%=i%></a>
<%
			} else if(endPage>lastPage){
%>
				<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=<%=i%>"><%=i%></a>
<%	
			}
			if(i == lastPage){	
				break;
			}
		}
		//다음 버튼
		// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
		if(endPage < lastPage){
%>
		<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=<%=currentPage+displayPage%>">다음</a>
<%
		}
		// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
		if(totalCount > ROW_PER_PAGE && currentPage != lastPage ){
%>
			<a class="btn btn-info" href="./selectMemberList.jsp?currentPage=<%=lastPage%>">끝으로</a>
<%
		}
%>
	</div>
</body>
</html>