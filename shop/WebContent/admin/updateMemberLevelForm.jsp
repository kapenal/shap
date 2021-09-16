<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%
	//인증 방어 코드 : 로그인 후에만 페이지 열람 가능
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		System.out.println("관리자계정으로 로그인하십시오.");
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	//한글 깨짐 방지
	request.setCharacterEncoding("utf-8");
	// 방어 코드
	if(request.getParameter("memberNo")==null || request.getParameter("searchMemberId")==null || request.getParameter("currentPage")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String searchMemberId = request.getParameter("searchMemberId");
	int currentPage = Integer.parseInt(request.getParameter("currentPage"));
	// 디버깅
	System.out.println(memberNo + " < updateMemberLevelForm.jsp param : memberNo");
	
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMemberOne(memberNo);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateMemberLevelForm.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<!-- 관리자 메뉴 include 절대 주소 -->
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		<div class="jumbotron">
	         <h1>등급 수정</h1>
		</div>
		<form method="post" action="<%=request.getContextPath()%>/admin/updateMemberLevelAction.jsp?memberNo=<%=memberNo%>&searchMemberId=<%=searchMemberId%>&currentPage=<%=currentPage%>">
			<table class="table table-bordered">
				<tr>
					<td>번호</td>
					<td><input type="text" name="memberNo" value="<%=member.getMemberNo()%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>아이디</td>
					<td><input type="text" name="memberId" value="<%=member.getMemberId()%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>변경할 등급을 선택하세요</td>
					<td>
						<select name="memberLevel">
							<option value="0">일반회원</option>
							<option value="1">관리자</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>이름</td>
					<td><input type="text" name="memberName" value="<%=member.getMemberName()%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>나이</td>
					<td><input type="text" name="memberAge" value="<%=member.getMemberAge()%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td>성별</td>
					<td><input type="text" name="memberGender" value="<%=member.getMemberGender()%>" readonly="readonly"></td>
				<tr>
				<tr>
					<td>최근 수정 날짜</td>
					<td><input type="text" name="updateDate" value="<%=member.getUpdateDate()%>" readonly="readonly"></td>
				<tr>
				<tr>
					<td>생성 날짜</td>
					<td><input type="text" name="creatDate" value="<%=member.getCreatDate()%>" readonly="readonly"></td>
				<tr>
			</table>
			<button type="submit" class="btn btn-light">수정 완료</button>
			<a href ="<%=request.getContextPath()%>/admin/selectMemberList.jsp?searchMemberId=<%=searchMemberId%>&currentPage=<%=currentPage%>" class="btn btn-light">취소</a>
		</form>
		
	</div>
</body>
</html>