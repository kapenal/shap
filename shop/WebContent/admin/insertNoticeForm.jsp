<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div style="text-align:right">
			<span class="text-warning"><%=loginMember.getMemberName()%></span>님 반갑습니다 <a href="<%=request.getContextPath()%>/logOut.jsp" class="btn btn-light" style="width:70pt;height:32pt;">로그아웃</a>
		</div>
		<!-- 메인 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>공지사항 작성</h1>
	         <h3><span class="badge badge-light"><a href ="<%=request.getContextPath()%>/index.jsp" class="text-dark">메인페이지</a></span></h3>
		</div>
		<form id="noticeForm" method="post" action="<%=request.getContextPath()%>/admin/insertNoticeAction.jsp">
			<table class="table table-bordered">
				<tr>
					<td>공지사항 제목 : <input type="text" id="noticeTitle" name="noticeTitle"></td>
				</tr>
				<tr>
					<td><textarea class="form-control" rows="5" id="noticeContent" name="noticeContent"></textarea></td>
				</tr>
			</table>
			<div style="text-align:right">
				<button  id="noticeBtn" type="button" class="btn btn-light" >작성 완료</button>
			</div>
			<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>" readonly="readonly">
		</form>
	</div>
	<script>
		$('#noticeBtn').click(function(){
			// 버튼을 클릭했을 때
			if($('#noticeTitle').val() == '') { // 제목이 공백이면
				alert('제목을 입력하세요');
				return;
			}
			if($('#noticeContent').val() == '') { // 내용이 공백이면
				alert('내용을 입력하세요');
				return;
			}
			$('#noticeForm').submit();
		});
	</script>
</body>
</html>