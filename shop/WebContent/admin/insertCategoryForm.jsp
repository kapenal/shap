<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
<%@ page import="dao.*"%>
<%
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");	
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 카테고리 이름 체크 방어 코드
	String categoryCheckName = "";
	if(request.getParameter("categoryCheckName") != null) {
		// 한글을 받을 시 ??로 표현됨
		categoryCheckName = request.getParameter("categoryCheckName");
	}
	System.out.println(request.getParameter("categoryCheckName") + " 여기가 문제");
	System.out.println(categoryCheckName + " 여기가 문제");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset=UTF-8">
<title>insertCategoryForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/insertMemberForm.jsp" class="bg-light text-dark" style="width:70pt;height:32pt;text-decoration:none;">로그아웃</a>
		</div>
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>카테고리 추가</h1>
		</div>
		<form id="categoryCheckForm" method="post" action="<%=request.getContextPath()%>/admin/selectCategoryNameCheckAction.jsp">
			 <table class="table table-bordered">
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" id="categoryCheckName" name="categoryCheckName"></td>
					<td>
						<button id="categoryCheckBtn" type="button">아이디 중복 검사</button>
					</td>
				</tr>
			</table>
		</form>
		<!-- 카테고리 추가 폼 -->
		<form id="categoryInsertForm" method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp?">
			<table class="table table-bordered">
				<tr>
					<td>카테고리 이름</td>
					<td><input type="text" id="categoryName" name="categoryName" value="<%=categoryCheckName%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>사용 여부</td>
					<td>
						<select id="categoryState" id="categoryState" name="categoryState">
							<option value="N">미사용</option>
							<option value="Y">사용</option>
						</select>
					</td>
				<tr>
			</table>
			<button id="categoryInsertBtn" type="button" class="btn btn-light">추가</button>
			<a href ="<%=request.getContextPath()%>/admin/selectCategoryList.jsp" class="btn btn-light">취소</a>
		</form>
	</div>
	<script>
		$('#categoryCheckBtn').click(function(){
			if($('#categoryCheckName').val() == '') { // 카테고리 이름이 공백이면
				alert('카테고리를 입력하세요');
				return;
			}
			$('#categoryCheckForm').submit();
		});
		
		$('#categoryInsertBtn').click(function(){
			if($('#categoryName').val() == '') { // 카테고리 이름이 공백이면
				alert('카테고리를 입력하세요');
				return;
			}
			if($('#categoryState').val() == '') { // 카테고리 상태가 공백이면
				alert('카테고리를 상태를 선택하세요');
				return;
			}
			$('#categoryInsertForm').submit();
		});
	</script>
</body>
</html>