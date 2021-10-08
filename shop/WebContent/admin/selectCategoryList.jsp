<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@page import="java.util.*"%>
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
	
	// CategoryDao 객체 
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = null;
	
	categoryList = categoryDao.selectCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectCategoryList.jsp</title>
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
	         <h1>카테고리 목록</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<div>
			<h2>카테고리 목록</h2>
		</div>
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>카테고리</th>
					<th>최근 갱신 날짜</th>
					<th>계정 생성 날짜</th>
					<th>사용 여부</th>
					<td>사용 여부 변경</td>
				</tr>
			</thead>
			<tbody>
				<%
					for(Category c : categoryList){
				%>
						<tr>
							<td><%=c.getCategoryName()%></td>
							<td><%=c.getUpdateDate()%></td>
							<td><%=c.getCreatDate()%></td>
							<td>
							<%
								if(c.getCategoryState().equals("N")) {
							%>
									<span>미사용</span>
							<%		
								} else if(c.getCategoryState().equals("Y")) {
							%>
									<span>사용</span>
							<%
								}
							%>
							</td>
									
							<td>
								<form id="updateState" method="post" action="<%=request.getContextPath()%>/admin/updateCategoryStateAction.jsp?categoryName=<%=c.getCategoryName()%>">
								<select id="categoryState" name="categoryState">
									<option value="N">미사용</option>
									<option value="Y">사용</option>
								</select>
								<button id="updateStateBtn" type="button">변경</button>
								</form>
							</td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<a href="<%=request.getContextPath()%>/admin/insertCategoryForm.jsp"><button >카테고리 추가</button></a>
	</div>
	<script>
		$('#updateStateBtn').click(function(){
			if($('#categoryState').val() == '') { // 사용여부가 공백이면
				alert('사용여부를 선택하세요');
				return;
			}
			$('#updateState').submit();
		});
	</script>
</body>
</html>