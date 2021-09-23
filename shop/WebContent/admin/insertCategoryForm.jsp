<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
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
	// 카테고리 이름 체크 방어코드
	String categoryCheckName = "";
	if(request.getParameter("categoryCheckName") != null) {
		// 한글을 받을 시 ??로 표현됨 \u0000000000uuulml
		categoryCheckName = request.getParameter("categoryCheckName");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>insertCategoryForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>카테고리 추가</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/selectCategoryNameCheckAction.jsp">
			 <table class="table table-bordered">
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" name="categoryCheckName"></td>
					<td>
						<button type="submit">아이디 중복 검사</button>
						<%=request.getParameter("idCheckResult")%>
					</td>
				</tr>
			</table>
		</form>
		<!-- 카테고리 추가 폼 -->
		<form method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp?">
			<table class="table table-bordered">
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" name="categoryName" value="<%=categoryCheckName%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>사용 여부</td>
					<td>
						<select name="categoryState">
							<option value="N">미사용</option>
							<option value="Y">사용</option>
						</select>
					</td>
				<tr>
			</table>
			<button type="submit" class="btn btn-light">추가</button>
			<a href ="<%=request.getContextPath()%>/admin/selectCategoryList.jsp" class="btn btn-light">취소</a>
		</form>
	</div>
</body>
</html>