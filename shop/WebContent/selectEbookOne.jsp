<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("ebookNo") == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// 멤버 no
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 상세 보기 호출
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	
	int orderCommentCurrentPage = 1;
	int orderCommentRowPerPage = 10;
	//orderCommentCurrentPage가 null이 아니라면 값을 얻음
	if(request.getParameter("orderCommentCurrentPage") != null){
		orderCommentCurrentPage = Integer.parseInt(request.getParameter("orderCommentCurrentPage"));
	}
	int beginRow = (orderCommentCurrentPage - 1) * orderCommentRowPerPage;
	// 댓글 목록 호출
   	ArrayList<OrderComment> orderComment = ebookDao.selectCommentList(ebookNo, beginRow, orderCommentRowPerPage);
	// 총 댓글 수 호출
	int orderCommentCount = ebookDao.orderCommentCount(ebookNo);
	OrderDao orderDao = new OrderDao();
	double avgScore = orderDao.selectOrderScoreAvg(ebookNo);
	
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	// 마지막 페이지
	// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
	int lastPage = orderCommentDao.selectCommentLastPage(orderCommentCount, orderCommentRowPerPage);
	// 화면에 보여질 페이지 번호의 갯수
	int displayPage = 10;
	System.out.println(orderCommentCurrentPage + "currentPage갯수");
	// 화면에 보여질 시작 페이지 번호
	int startPage = ((orderCommentCurrentPage - 1) / displayPage) * displayPage + 1;
	// 디버깅
	System.out.println("startPage : "+startPage);
	int endPage = startPage + displayPage - 1;
	// 디버깅
	System.out.println("endPage : "+endPage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectEbookOne.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>상세 보기</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<table class="table table-bordered">
		<tr>
			<td>책 번호 : <%=ebook.getEbookNo()%></td>
			<td colspan="2"><%=ebook.getEbookIsbn() %>
			<td><%=ebook.getCategoryName()%></td>
			
		</tr>
		<tr>
			<td>제목 : <%=ebook.getEbookTitle()%></td>
			<td>저자 : <%=ebook.getEbookAuthor()%></td>
			<td><%=ebook.getEbookPageCount()%>페이지</td>
			<td><%=ebook.getEbookPrice()%>원</td>
		</tr>
		<tr>
			<td><img src="<%=request.getContextPath()%>/image/<%=ebook.getEbookImg()%>" width="200" height="200"></td>
			<td colspan="3"><%=ebook.getEbookSummary()%></td>
		</tr>
		</table>
		<!-- 주문 입력하는  폼 -->
		<%
			if(loginMember == null){
		%>
				<div>로그인 후에 주문이 가능합니다. <a href="<%=request.getContextPath()%>/loginForm.jsp">로그인하러 가기</a></div>
		<%	
			} else {
		%>
				<form method="post" action="<%=request.getContextPath()%>/insertOrderAction.jsp">
				<input type="hidden" name="ebookNo" value="<%=ebookNo%>">
				<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>">
				<input type="hidden" name="orderPrice" value="<%=ebook.getEbookPrice()%>">
				<button type="submit">주문하기</button>
				</form>
		<%		
			}
		%>
		<br>
		<hr>
		<h3>
			상품 후기 
		</h3>
		<div>
			<h4>총 상품 후기(<%=orderCommentCount%>) 평균 별점(<%=avgScore%>)</h4>
		</div>
		<!-- 이 상품의 별점의 평균 -->
		<!-- SELECT AVG(order_score) FROM order_comment WHERE ebook_no=? GROUP BY ebook_no -->
		<!-- 이 상품의 후기(페이징) -->
		<!-- SELECT * FROM order_comment WHERE ebook_no=? LIMIT ?, ? -->
		<div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="width:10%; text-align:center">별점</th>
					<th>후기 내용</th>
					<th style="width:20%; text-align:center">작성 날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
				for(OrderComment c : orderComment) {     
	            %>
					<tr>
						<td style="width:10%; text-align:center">별점 : <%=c.getOrderScore()%></td>
						<td><%=c.getOrderCommentContent()%></td>
						<td style="width:10%; text-align:center"><%=c.getCreateDate()%></td>
					</tr>
	          	<%
					}
	          	%>
	           </table>
           </tbody>
		</div>
		<%
			// lastPage가 0이면 아무 댓글도 없기때문에 처음으로,이전,숫자페이징,다음,끝으로 안보이게 하기 위해 if문 사용
			if(lastPage != 0){
				// total이 commentRowPerPage보다 크면 2페이지 이상이고 commentCurrentPage가 1보다 크면 2페이지 이상의 페이지를 보기 때문에 처음으로 보이도록 함
				if(orderCommentCurrentPage > orderCommentRowPerPage && orderCommentRowPerPage > 1 ){
	%>		
				<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=1&ebookNo=<%=ebookNo%>">처음으로</a>
	<%
				}
				// 이전 버튼
				// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
				if(startPage > displayPage){
	%>
				<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=<%=startPage-displayPage%>&ebookNo=<%=ebookNo%>">이전</a>
	<%
				}
				// 페이지 번호 버튼
				for(int i=startPage; i<=endPage; i++) {
					if(orderCommentCurrentPage == i){
	%>
						<a class="btn btn-primary" href="<%=request.getContextPath()%>/admin/selectEbookList.jsp?orderCommentCurrentPage=<%=i%>&ebookNo=<%=ebookNo%>"><%=i%></a>
	<%	
					} else if(endPage<lastPage){
	%>
						<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=<%=i%>&ebookNo=<%=ebookNo%>"><%=i%></a>
	<%
					} else if(endPage>lastPage){
	%>
						<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=<%=i%>&ebookNo=<%=ebookNo%>"><%=i%></a>
	<%	
					}
					// lastPage와 같은 수가 되면 break로 더이상 숫자페이징을 만들지 않음
					if(i == lastPage || lastPage == 0){	
						break;
					}
				}
				// 다음 버튼
				// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
				if(endPage < lastPage){
	%>
				<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=<%=startPage+displayPage%>&ebookNo=<%=ebookNo%>">다음</a>
	<%
				}
				// totalCount가 10보다 크면 다음페이지가 있기때문에 끝으로 보이도록 설정
				if(orderCommentCount > orderCommentRowPerPage && orderCommentCurrentPage != lastPage ){
	%>
					<a class="btn btn-info" href="./selectBoardOne.jsp?orderCommentCurrentPage=<%=lastPage%>&ebookNo=<%=ebookNo%>">끝으로</a>
	<%
				}
			}
	%>
	
	</div>
</body>
</html>