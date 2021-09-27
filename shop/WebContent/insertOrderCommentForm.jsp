<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	
	// 파라메터값 받기
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	String ebookTitle = request.getParameter("ebookTitle");
	//  디버깅 코드
	System.out.println(orderNo + " < insertOrderCommentForm param : orderNo");
	System.out.println(ebookNo + " < insertOrderCommentForm param : ebookNo");
	System.out.println(ebookTitle + " < insertOrderCommentForm param : ebookTitle");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertOrderCommentForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>후기 작성</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/insertOrderCommentAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>주문 번호 : <input type="text" name="orderNo" value="<%=orderNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>책 제목 : <input type="text" name="ebookTitle" value="<%=ebookTitle%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td><textarea class="form-control" rows="5" name="orderCommentContent"></textarea></td>
				</tr>
				<tr>
					<td>
						별점
						<select name="orderScore">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
						</select>
					</td>
				<tr>
			</table>
			<button type="submit" class="btn btn-light">후기 입력</button>
			<input type="hidden" name="ebookNo" value="<%=ebookNo%>" readonly="readonly">
		</form>
	</div>
</body>
</html>