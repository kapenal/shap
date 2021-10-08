<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	if(session.getAttribute("loginMember") == null){
		System.out.println("로그인하십시오");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	Member loginMember = (Member)session.getAttribute("loginMember");
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>후기 작성</h1>
		</div>
		<form id="orderCommentForm" method="post" action="<%=request.getContextPath()%>/insertOrderCommentAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>주문 번호 : <input type="text" id="orderNo" name="orderNo" value="<%=orderNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>책 제목 : <input type="text" id="ebookTitle" name="ebookTitle" value="<%=ebookTitle%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td><textarea class="form-control" rows="5" id="orderCommentContent" name="orderCommentContent"></textarea></td>
				</tr>
				<tr>
					<td>
						별점
						<select id="orderScore" name="orderScore">
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
			<button id="orderCommentBtn" type="button" class="btn btn-light">후기 입력</button>
			<input type="hidden" name="ebookNo" value="<%=ebookNo%>" readonly="readonly">
		</form>
	</div>
	<script>
		$('#orderCommentBtn').click(function(){
			// 버튼을 클릭했을 때
			if($('#orderCommentContent').val() == '') { // 후기가 공백이면
				alert('후기를 입력하세요');
				return;
			}
			if($('#orderScore').val() == '') { // 별점이 공백이면
				alert('별점을 입력하세요');
				return;
			}
			$('#orderCommentForm').submit();
		});
	</script>
</body>
</html>